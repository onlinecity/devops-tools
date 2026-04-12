#!/usr/bin/env bash
# Ensures all git submodules have content (are populated), without modifying
# submodules that are already initialized -- even if they are at a different
# SHA or have local changes.
#
# Only submodules marked with '-' by `git submodule status` (uninitialized /
# empty) are populated.  Submodules marked ' ' (up to date), '+' (different
# SHA / local commits) or 'U' (merge conflict) are left completely untouched.
#
# This is intentionally non-intrusive: it is safe to run on every devbox shell
# enter without risking loss of in-progress work inside a submodule.

set -euo pipefail


# Guard order matters: checks `.gitmodules` first (fast exit), then `git rev-parse`
# to see if the repository is a git repository as all.
# Gracefully skip when there is nothing to do
if [ ! -f .gitmodules ]; then
    echo "ensure-submodules-populated: git submodules not detected, skipping"
    exit 0
fi

if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "ensure-submodules-populated: not inside a git repository, skipping"
    exit 0
fi

# Collect the paths of uninitialized submodules only.
# `git submodule status` output format:  <prefix><sha> <path> [<description>]
# prefix '-' means the submodule has never been initialized (directory is empty).
mapfile -t uninitialized < <(git submodule status | awk '$0 ~ /^-/ { print $2 }')

if [ "${#uninitialized[@]}" -eq 0 ]; then
    echo "ensure-submodules-populated: all git submodules are already initialized, skipping"
    exit 0
fi

echo "ensure-submodules-populated: found ${#uninitialized[@]} uninitialized submodule(s), populating..."

for path in "${uninitialized[@]}"; do
    echo "  populating submodule: ${path}"
    # --init      : register the submodule if not yet in .git/config
    # --recursive : also populate nested submodules inside this one
    # --           : explicit end-of-options to safely handle unusual paths
    git submodule update --init --recursive -- "${path}"
done

echo "ensure-submodules-populated: done"
