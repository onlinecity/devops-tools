# DevOps Tools
Tools for DevOps projects

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

### Base config

This plugin has the baseline of tools needed for a DevOps project. 

This includes:
  * Python, including a virtual environment
  * Pre-commit and linting hooks
  * tfswitch and tflint for working with terraform
  * Taskfile

#### Python and pip

The plugin creates a python virtual envrionment, activates it and installs pip requirements. Note that it expects a `requirements.txt` in the root of the project for pip installation to work. If your requirements file is located elsewhere, you can create a "root" requirements.txt with a link to your other requirements file. 

Example `requirement.txt`:

```
-r configure/requirements.txt
```

#### Scripts

The base config plugin includes some scripts to help bootstrap a new project.

Available scripts:
  * __bootstrap-envrc-private__ - this command will setup direnv for using a private .envrc file

#### TODO (future plans ?)

If needed we could split the base config into optional plugins eg. a python plugin, a terraform plugin etc.

