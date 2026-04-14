#!/usr/bin/env bash
# Git submodule BATS helper functions for ensure-submodules-populated.sh tests.
#
# NOTICE refers to BATS special variables
# https://bats-core.readthedocs.io/en/stable/writing-tests.html#run-test-other-commands
#
# Provides utilities to build isolated local git repo trees (gitrepo +
# bare "remotes") in throwaway temp directories. No network access is required.

# Ensure some error handling.
# Most importantly is the -u option to catch misuse of the script if the BATS special variables are not set for some reason.
set -euo pipefail

# Git identity used for all test commits to avoid depending on developer's global config.
# Usable in any test that needs to make git commits.
GIT_IDENTITY=(-c user.email="test@test" -c user.name="test for devops-tools with bats")

# ---------------------------------------------------------------------------
# create_bare_remote <dest_dir>
#
# Creates a local bare git repo at <dest_dir> with a single empty initial
# commit. Used as the "remote" URL for submodule registrations so no network
# access is needed.
# ---------------------------------------------------------------------------
create_bare_remote() {
    local dest="$1"
    local tmp="$dest.tmp"
    mkdir "$tmp"
    git -C "$tmp" init -b main
    git -C "$tmp" "${GIT_IDENTITY[@]}" commit --allow-empty -m "initial"
    git clone --bare "$tmp" "$dest"
    rm -rf "$tmp"
}

# ---------------------------------------------------------------------------
# create_bare_remote_with_child_submodule <dest_dir> <child_remote_dir>
#
# Creates a local bare git repo at <dest_dir> that itself contains a submodule
# pointing at <child_remote_dir>. Used to set up the nested-submodule test.
# ---------------------------------------------------------------------------
create_bare_remote_with_child_submodule() {
    local dest="$1"
    local child_remote="$2"
    local tmp="$dest.tmp"
    mkdir "$tmp"
    git -C "$tmp" init -b main
    git -C "$tmp" "${GIT_IDENTITY[@]}" submodule add "$child_remote" child
    git -C "$tmp" "${GIT_IDENTITY[@]}" commit -m "add child submodule"
    git clone --bare "$tmp" "$dest"
    rm -rf "$tmp"
}

# ---------------------------------------------------------------------------
# create_gitrepo <gitrepo_dir>
#
# Initialises an empty git repo at <gitrepo_dir> with an initial commit.
# Submodules are added separately via add_submodule_to_gitrepo.
# ---------------------------------------------------------------------------
create_gitrepo() {
    local dir="$1"
    mkdir "$dir"
    git -C "$dir" init -b main
    git -C "$dir" "${GIT_IDENTITY[@]}" commit --allow-empty -m "initial"
}

# ---------------------------------------------------------------------------
# add_submodule_to_gitrepo <gitrepo_dir> <remote_dir> <submodule_path>
#
# Adds a submodule at <submodule_path> inside the gitrepo, pointing at
# <remote_dir>. Commits the change so the gitrepo records the submodule SHA.
# ---------------------------------------------------------------------------
add_submodule_to_gitrepo() {
    local gitrepo="$1"
    local remote="$2"
    local subpath="$3"
    git -C "$gitrepo" "${GIT_IDENTITY[@]}" submodule add "$remote" "$subpath"
    git -C "$gitrepo" "${GIT_IDENTITY[@]}" commit -m "add submodule $subpath"
}

# ---------------------------------------------------------------------------
# mark_submodule_uninitialized <gitrepo_dir> <submodule_path>
#
# Deinits the submodule: removes the working-tree content and the .git/config
# entry. `git submodule status` will show '-' prefix for this path.
# ---------------------------------------------------------------------------
mark_submodule_uninitialized() {
    local gitrepo="$1"
    local subpath="$2"
    git -C "$gitrepo" submodule deinit "$subpath"
}

# ---------------------------------------------------------------------------
# mark_submodule_at_different_sha <gitrepo_dir> <submodule_path>
#
# Makes a new commit inside the already-checked-out submodule directory.
# The gitrepo still records the old SHA, so `git submodule status`
# shows '+' prefix (checked out at a SHA different from what is recorded).
# ---------------------------------------------------------------------------
mark_submodule_at_different_sha() {
    local gitrepo="$1"
    local subpath="$2"
    git -C "$gitrepo/$subpath" "${GIT_IDENTITY[@]}" commit --allow-empty -m "local commit in submodule"
}

# ---------------------------------------------------------------------------
# submodule_sha <gitrepo_dir> <submodule_path>
#
# Returns the current HEAD SHA of the checked-out submodule.
# ---------------------------------------------------------------------------
submodule_sha() {
    local gitrepo="$1"
    local subpath="$2"
    git -C "$gitrepo/$subpath" rev-parse HEAD
}
