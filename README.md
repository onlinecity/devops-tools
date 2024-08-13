# DevOps Tools

Tools for onlinecity.io DevOps projects.

This repository hosts our devbox plugin(s) and common taskfile configurations. Due to technical reasons, it needs to be **public** for taskfile to use remote taskfiles (currently, maybe support for private comes later).

For our common taskfile files, see the `taskfiles` folder and [Taskfiles](#taskfiles) section below.

Documentation of our devbox plugins are in the [Devbox plugins](#devbox-plugins) section

Changelog is autogenerated by release please, see [CHANGELOG.md](CHANGELOG.md), but check migration notes for major changes last in this readme in the [Migration notes](#migration-notes) section.

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

This plugin has the baseline of tools needed for various DevOps projects.

This includes:

* Python, and activation of a virtual environment if `requirements.txt` is present in the root of the repository using this plugin
* Pre-commit and linting hooks, and CI Github actions for it.
* tenv, tflint and terraform-docs for working with terraform or tofu
* Taskfile or reusable tasks

Assumptions:

* You use either Bash or Zsh as your shell.

#### Python and virtual environments

The plugin creates a python virtual environment, activates it and installs pip requirements if `requirements.txt` exists in the root of the project. If your requirements file is located elsewhere, you can create a "root" requirements.txt with a link to your other requirements file.

Example `requirement.txt`:

```requirements.txt
-r customlocation/requirements.txt
```

Taskfile tasks, or devbox scripts might add to the base `requirements.txt` in the projects to ensure other requirements files are loaded, like the `bootstrap-taskfile` or `bootstrap-ansible` that add the line `-r configure/requirements.txt` into `requirements.txt`.

Any Python package requirements needed for the devbox plugin itself, are managed in [`config/devbox-requirements.txt`](config/devbox-requirements.txt) and additionally installed during devbox init hooks, separately from the project requirements that might come from other sources or other devbox commands that manage those.

##### Requirements in repositories vs. defaults from devbox

There has been created a devbox task, that merges an eventual `configure/requirements.txt.local` with a `requirements.txt.dist` from this devbox repository. This means that we can give some default python requirements from here, and not need to handle requirements in the infrastructure repositories. Updates for the requirements can be done easily from here.

Update the `configure/requirements.txt` by running `devbox run ansible-requirements` from the root of the platform repository. This `configure/requirements.txt` must then be included in `requirements.txt` as [described above](#python-and-virtual-environments).

#### Terraform and opentofu

The plugin does not install neither terraform, nor opentofu but uses `tenv` which handles installation of both based on `required_version` in the project.

The devbox plugin initialization, ensures through aliases you can't call the wrong tool, as it makes a dummy alias based based on the terraform/opentofu lock file.

Using 'tenv' you need to install either, the selection of the correct one, isn't handled by the devbox plugin yet.

#### Scripts

The base config plugin includes some scripts to help bootstrap a new project.

Available scripts:
  * __bootstrap-envrc-private__ - this command will setup direnv for using a private .envrc file
  * __bootstrap-pre-commit__ - this command will create a pre-commit config with lint and editorconfig
  * __bootstrap-ci-lint__ - this command will add Github actions for linting with the same tools as pre-commit but on all files (not just changed ones). editorconfig-checker accepts a config file `.ecrc` but it doesn't have to exist.
  * __bootstrap-taskfile__ - this command will create a taskfile including common taskfile from the repo
  * __bootstrap-release-please__ - this command will create a release-please github action file using the __simple__ release type
  * __bootstrap-ansible__ - this command will create a basic ansible.cfg file and the `configure` folder
  * __migration-*__ - migration scripts for moving from one version of this project to another, see [Migration notes](#migration-notes) for details

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

## Migration notes

As a first effort of trying to keep projects using the taskfile and devbox plugins up to date and aligned across version, we try to implement migration command between major versions so these can be used a clean up commands.

Additions are typically not breaking, but moving configuration to other files or removing configuration might be breaking and thus should be cleaned up.

We supply devbox run commands for migrations, e.g. `devbox run migration-1x-to-2x` for migrating from version 1.x to 2.x. The command or helper scripts document the details.
