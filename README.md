# DevOps Tools

Tools for onlinecity.io DevOps projects.

This repository hosts our devbox plugin(s) and common taskfile configurations. Due to technical reasons, it needs to be **public** for taskfile to use remote taskfiles (currently, maybe support for private comes later).

For our common taskfile files, see the `taskfiles` folder and [Taskfiles](#taskfiles) section below.

Documentation of our devbox plugins are in the [Devbox plugins](#devbox-plugins) section

## Devbox plugins

In the devbox-plugins folder are plugins for our devbox setup. Plugins are installed by adding the plugin to the projects devbox.json file in the include section. The url looks like standard github urls so we can use `ref` to target a specific tag or branch. Note that this is not a documented feature by devbox, only `dir` as parameter.

Example:

```json
  ...
  "include": [
    "github:onlinecity/devops-tools?ref=master&dir=devbox-plugins/base-config"
  ]
  ...
```

| Plugin | Description |
| --- | --- |
| [base-config](#base-config) | Base configuration for a DevOps project - our initial proof-of-concept with everything. |

### Base config

This plugin has the baseline of tools needed for a DevOps project.

This includes:

* Python, including a virtual environment if `requirements.txt` is present in the root of the repository
* Pre-commit and linting hooks
* tenv, tflint and terraform-docs for working with terraform or tofu
* Taskfile

Assumptions:

* You use either Bash or Zsh as your shell.

#### Python and pip

The plugin creates a python virtual environment, activates it and installs pip requirements if `requirements.txt` exists in the root of the project. If your requirements file is located elsewhere, you can create a "root" requirements.txt with a link to your other requirements file.

Example `requirement.txt`:

```
-r configure/requirements.txt
```

#### Terraform

The plugin does not install terraform but instead installs tfswitch to help with getting the correct terraform version. We require our terraform project to define the terraform version with `required_version` and then use tfswitch to install it.

#### Scripts

The base config plugin includes some scripts to help bootstrap a new project.

Available scripts:
  * __bootstrap-envrc-private__ - this command will setup direnv for using a private .envrc file
  * __bootstrap-pre-commit__ - this command will create a basic pre-commit config with yamllint and tflint
  * __bootstrap-taskfile__ - this command will create a taskfile including common taskfile from the repo
  * __bootstrap-release-please__ - this command will create a release-please github action file using the __simple__ release type
  * __bootstrap-ansible__ - this command will create a basic ansible.cfg file and the `configure` folder

## Taskfiles

The devbox script common `bootstrap-taskfile` will create a taskfile in the root of the projects where we use our devbox plugins, and add the common taskfiles from this repository as remote task files.

## Roadmap

* If needed we could split the base config into optional plugins eg. a python plugin, a terraform plugin etc.
* Make bootstrap scripts idempotent (seen from the consuming projects point of view) or consider the bootstrap vs configuration concept described below.
* Notice the devbox have a nice feature of writing a project readme. We don't use it yet, but could create a 2nd readme in our projects and under our project specific tooling and usage sections we always have in our project just link to this 2nd readme that is automatically generated and be kept updated automatically as well. Only problem if the autogenerated readme contain user specific paths, but it might be possible to clean up with `sed` or just wait for devbox to improve.

### Bootstrap vs configuration scripts

The current bootstrap scripts are not all idempotent, which are not really a problem due to their naming. However as we plan to have one source of truth for common configuration, we need some kind of update process that can maintain the configuration in the projects.

It bootstrap script was idempotent, they could be used with possibly a more saying name. Like `configure-< something >`. Or `setup-< something >`.

As a _configuration concept_ we need the scripts to be idempotent, as well as support some kind of merge process like the simple one shown for `bootstrap-ansible`. A similar process could be used with json, yaml and other file formats. Alternative more advances use-cases could use cue-lang, jsonnet etc.

With idempotence, and merging, we can further develop the process to automatically keep consuming projects updated with the latest configuration. This could be done with dependabot, or a custom script that checks for new versions of the devbox plugin and runs the `configure` command in the projects and automatically creates a PR with the updated configuration. Obviously including running tests.
