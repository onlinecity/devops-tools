#!/bin/bash

# This script is managed from devbox. Do not touch.
# Used to merge the ansible-requirements.txt.dist and configure/requirements.txt.local files

set -e

# If we have a configure/requirements.txt.local file, we merge it with the ansible-requirements.txt.dist file.
if [ -e configure/requirements.txt.local ]; then
    # remove old file first, if it exists because merge_requirements will not overwrite and create new ones
    rm -f requirements-merged.txt
    # produced requirements-merged.txt in the root of the repository
    merge_requirements {{ .Virtenv }}/ansible-requirements.txt.dist configure/requirements.txt.local

    # Add little helper and traceability msg and output to final file and then add merged result
    cat << EOF > configure/requirements.txt
# This file is the result of a merge of requirements files, always taking the union of Python packages, and the last version of each package.
# The merge is done by our devops tools, and a devbox run command merging two files:
# -  {{ .Virtenv }}/ansible-requirements.txt.dist
# - configure/requirements.txt.local
# NOTICE comments are stripped out, so check the two files for comments if in doubt of why packages are included.
EOF
    cat requirements-merged.txt >> configure/requirements.txt
    rm requirements-merged.txt
else
    # Or else we simply just use the ansible-requirements.txt.dist file provided from devbox (this also contains comments and traceability information)
    cp {{ .Virtenv }}/ansible-requirements.txt.dist configure/requirements.txt
fi

# By touching the file, devbox will re-initialize itself, and update environments.
touch devbox.json
