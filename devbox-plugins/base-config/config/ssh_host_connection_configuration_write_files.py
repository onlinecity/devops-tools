# This script automated are ssh configuration files for ssh host connections, based on the input data from Terraform outputs.
# Each host will get a configuration file and a known_hosts file, with the ssh configuration data.
# It follows our internal devops docs about Automated ssh connection configuration for hosts, and allows us to easily connect to hosts,
# and use TAB completion.
#
# You need to configure you own ssh client to read the files outputted by this script, to benefit from the configuration.
# This means it is purely opt-in.
# Local ssh client can read included files like in your personal ~/.ssh/config file something like this:
# Include ~/<your git repository configuration>-<common infrastructure repository name>/provision/*/.ssh/config.d/*
# Alternatively you can write them to the ~/.ssh/config.d/ directory, and include with:
#'Include config.d/*'
#
# This script is supposed to be distributed and used through our devops-tools project with devbox plugins and taskfiles.
#
# There is - yet - no coordination and verification of compatibility with this script and the output from Terraform the script depends on.
#
# Design notes:
# - Using Jinja2 templating, as it is well known and already used as part of Ansible work.
# - Haven't implemented json schema validation, as the script will fail if the input data is not as expected. Instead we will later focus on the contract between the Terraform output and this script, and test earlier in the modules instead.

import argparse # reading the command line parameters
import json # reading the input file
import os # file path magic

from jinja2 import Environment, FileSystemLoader # template magic



# Argument parsing and script inputs, and help text
parser = argparse.ArgumentParser(
        description="Writes ssh host connection configuration files, to 'config.d' and 'known_hosts.d' dirs in chosen output dir from the input json data from Terraform outputs. Directories will be created if they do not exist (recursively).")
parser.add_argument('-i', '--input', help='The input file with the json data from Terraform outputs.', required=True, metavar='terraform-output-as-json.json')
#parser.add_argument('-o', '--output_base_dir', help='The output directory for the ssh host connection configuration files.', required=True, metavar=".ssh/")
parser.add_argument('-c', '--config_dir', help='The output directory for the ssh host configuration files for the hosts.', required=False, metavar=".ssh/config.d/")
parser.add_argument('-k', '--known_hosts_dir', help='The output directory for the known_hosts files for the hosts, pointed to from within the host configuration files.', required=False, metavar=".ssh/known_hosts.d/")
args = parser.parse_args()


# we distribute the templates with this script itself:
template_dir = os.path.abspath(os.path.dirname(__file__) + "/ssh_host_connection_configuration_templates")

# prepare Jinja templating and load all the templates - used by name of the file later on
environment = Environment(loader=FileSystemLoader(template_dir))

# Define output dirs, as full path and define path for known_hosts files as this needs to hardcoded
# in the ssh configuration files as a full path.
# We add this a global variable to the Jinja2 templates, so we can use it in the templates.
config_output_dir = os.path.abspath(args.config_dir)
known_hosts_output_dir = os.path.abspath(args.known_hosts_dir)
os.makedirs(config_output_dir, exist_ok=True)
os.makedirs(known_hosts_output_dir, exist_ok=True)

# Location to known hosts files have to been known and written to the ssh config files unfortunately, so we pass it as a global variable to the Jinja2 templates so it can be hardcoded in the ssh config files in the 'UserKnownHostsFile' path.
# That specific ssh configuration directive 'UserKnownHostsFile' support other ways, we cant't use:
# UserKnownHostsFile ${KNOWN_HOSTS_FILE_PATH}/<something> - we can't use environment variables, as we can't control the environment in such details on every operators machine. Hard to maintain.
# Relative path with e.g. 'UserKnownHostsFile .ssh/known_hosts.d/<filename>' - isn't good either, if this is inside say a project as we then can't use ssh config files automatically from other paths as it is not relative the the configuration file.
# Finally wildcards and path expansions isn't honored for 'UserKnownHostsFile' so not an option either.
# Hardcoding works, and we template the path in.
global_vars = {
    "knownhostfiles_path": known_hosts_output_dir,
    "script_file_name": os.path.abspath(__file__),
    "input_file_name": os.path.abspath(args.input)
}
ssh_config_template_file_name = "ssh_host_connection_config.conf.j2"
ssh_config_template = environment.get_template(ssh_config_template_file_name, globals=global_vars)
ssh_knownhost_template_file_name = "ssh_host_connection_config.knownhost.j2"
ssh_knownhost_template = environment.get_template(ssh_knownhost_template_file_name, globals=global_vars)


file = open(args.input)
json_data = json.load(file)

for hosts in json_data["hosts"]["value"]:
    for host_data in hosts:
        vm_name = hosts[host_data]["ssh_host_connection_configuration_data"]["vm_name"]
        ssh_config_filename = config_output_dir + "/" + vm_name + ".conf"
        ssh_knownhost_filename = known_hosts_output_dir + "/" + vm_name + ".known_hosts"

        ssh_host_connection_configuration_data = hosts[host_data]["ssh_host_connection_configuration_data"]

        template_file_name = template_dir + "/" + ssh_config_template_file_name
        content = ssh_config_template.render(ssh_host_connection_configuration_data, template_file_name=template_file_name)
        with open(ssh_config_filename, mode='w', encoding='utf-8') as document:
            document.write(content)

        template_file_name = template_dir + "/" + ssh_knownhost_template_file_name
        content = ssh_knownhost_template.render(ssh_host_connection_configuration_data, template_file_name=template_file_name)
        with open(ssh_knownhost_filename, mode='w', encoding='utf-8') as document:
            document.write(content)
