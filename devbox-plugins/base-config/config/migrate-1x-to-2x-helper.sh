#! /usr/bin/env bash

set -eoux pipefail

echo 'This migrates and cleans up the devbox configuration from bootstrap cmd applied in version 1.x to 2.x'


echo "Cleaning up after changed bootstrap-taskfile file command that added requirements in provision/reuirements.txt file which are now present in the devbox requirements file"
# check if file only contain our added lines, then remove it else just edit inline removing our lines:
if [[ -f provision/requirements.txt ]]
then
    if md5sum -c <<< '95ba778a3398cbbd4688b8a959f13b91  provision/requirements.txt'
    then
        rm -v provision/requirements.txt
        # in case it is removed, also remove the load from possible root project requirements file
        sed -i '/# Add required Python packages for provision and taskfile/,/-r provision\/requirements.txt/d' requirements.txt || true
        # and if added by older version without comment, remove it also
        sed -i '/-r provision\/requirements.txt/d' requirements.txt || true
    else
        sed -i '/# Use for writing ssh host connection configuration files/,/jinja2/d' provision/requirements.txt || true
    fi
fi

echo 'Migration clean up done'
