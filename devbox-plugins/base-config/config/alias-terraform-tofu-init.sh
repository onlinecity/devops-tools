#!/bin/bash

# Used to configure terraform/tofu aliases, and fake alias for the one not used to avoid
# confusion about which kind of project this is.

set -eo pipefail

if [[ -d provision ]];
then
    LOCKFILE=$(find ./provision -type f -name '.terraform.lock.hcl' | head -n1)

    if [[ ! -z "${LOCKFILE}" ]]
    then
        if head -n1 "${LOCKFILE}" | grep -q "tofu init"
        then
            mkdir -p .aliases
            echo 'echo \"this project uses tofu\"' > .aliases/terraform
            chmod +x .aliases/terraform
            echo "open tofu project, made fake terraform alias"
        else
            mkdir -p .aliases
            echo 'echo \"this project uses terraform\"' > .aliases/tofu
            chmod +x .aliases/tofu
            echo "terraform project, made fake tofu alias"
        fi
    else
        echo "Provision folder found, but no terraform lock file found, skip terraform-opentofu alias setup"
    fi

else
    echo "This project do not provision, skip terraform-opentofu alias setup"
fi
