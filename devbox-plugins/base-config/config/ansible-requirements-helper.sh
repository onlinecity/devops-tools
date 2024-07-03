#!/bin/bash

# This script is managed from devbox. Do not touch.
# Used to merge the ansible-requirements.txt.dist and configure/requirements.txt.local files

set -e

# If we have a configure/requirements.txt.local file, we merge it with the ansible-requirements.txt.dist file.
if [ -e configure/requirements.txt.local ]; then
    rm -f requirements-merged.txt
    merge_requirements {{ .Virtenv }}/ansible-requirements.txt.dist configure/requirements.txt.local
    mv requirements-merged.txt configure/requirements.txt
else
    # Or else we simply just use the ansible-requirements.txt.dist file provided from devbox.
    cp {{ .Virtenv }}/ansible-requirements.txt.dist configure/requirements.txt
fi

# By touching the file, devbox will re-initialize itself, and update environments.
touch devbox.json