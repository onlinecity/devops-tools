#!/usr/bin/env bats
# FIXME docs note! Resolve paths relative to this test file so the suite can be run from any cwd
#
# Tests for the script relative to this Bats test file:
SCRIPT_UNDER_TEST="$BATS_TEST_DIRNAME/../config/ensure-submodules-populated.sh"
#
#
# Strategy: each test builds a real local git repo tree (gitrepo + bare
# "remotes") in a throwaway temp directory so no network access is needed and
# no developer state is touched.
#
#
#
# Only need load these once for all the tests in here
# bats-support / bats-assert libraries are loaded from pinned submodules
load "$BATS_TEST_DIRNAME/libs/bats-support/load.bash"
load "$BATS_TEST_DIRNAME/libs/bats-assert/load.bash"
# our own helper functions - generic as well as some specific
load "$BATS_TEST_DIRNAME/helpers.bash"
load "$BATS_TEST_DIRNAME/git-submodule-helpers.bash"

# ---------------------------------------------------------------------------
# Lifecycle
# ---------------------------------------------------------------------------

setup() {
    # Isolate git config to a throwaway file so developer's global config is not
    # affected and file:// submodule clones are allowed (blocked by default since git 2.38)
    export GIT_CONFIG_GLOBAL="$BATS_TEST_TMPDIR/.gitconfig"
    git config --global protocol.file.allow always
}

# Teardown not used, because we use temporary BATS generated dirs that are automatically cleaned.
# Only clean cruft left outside those dirs.
#teardown() {
#
#}

# ---------------------------------------------------------------------------
# Test 1: no git submodules → exits cleanly with no output
# ---------------------------------------------------------------------------
@test "no git submodules exits cleanly with no output" {
    local gitrepo="$BATS_TEST_TMPDIR/repo"
    create_gitrepo "$gitrepo"

    cd "$gitrepo"
    run bash "${SCRIPT_UNDER_TEST}"

    assert_success
    # All cases should include a small foot-print of the script was running:
    assert_output "ensure-submodules-populated: git submodules not detected, skipping"
}

# ---------------------------------------------------------------------------
# Test 2: not a git repo → exits cleanly, prints skipping message
# ---------------------------------------------------------------------------
@test "not a git repo exits cleanly with skipping message" {
    local plain_dir="$BATS_TEST_TMPDIR/plain"
    mkdir -p "$plain_dir"
    # Script checks .gitmodules first for faster skipping
    # so create a stub so it reaches the later checks in the script
    touch "$plain_dir/.gitmodules"

    cd "$plain_dir"
    run bash "${SCRIPT_UNDER_TEST}"

    assert_success
    # All cases should include a small foot-print of the script was running:
    assert_output --partial "ensure-submodules-populated: not inside a git repository, skipping"
}

# ---------------------------------------------------------------------------
# Test 3: all submodules already populated → no changes, no output
# ---------------------------------------------------------------------------
@test "all submodules already populated produces no output and changes nothing" {
    local remote_a="$BATS_TEST_TMPDIR/remote-a.git"
    local remote_b="$BATS_TEST_TMPDIR/remote-b.git"
    local gitrepo="$BATS_TEST_TMPDIR/repo"

    create_bare_remote "$remote_a"
    create_bare_remote "$remote_b"
    create_gitrepo "$gitrepo"
    add_submodule_to_gitrepo "$gitrepo" "$remote_a" "sub-a"
    add_submodule_to_gitrepo "$gitrepo" "$remote_b" "sub-b"

    local sha_a_before sha_b_before
    sha_a_before=$(submodule_sha "$gitrepo" "sub-a")
    sha_b_before=$(submodule_sha "$gitrepo" "sub-b")

    cd "$gitrepo"
    run bash "${SCRIPT_UNDER_TEST}"

    assert_success
    # All cases should include a small foot-print of the script was running:
    assert_output "ensure-submodules-populated: all git submodules are already initialized, skipping"

    # SHAs must be unchanged
    assert_equal "$(submodule_sha "$gitrepo" "sub-a")" "$sha_a_before"
    assert_equal "$(submodule_sha "$gitrepo" "sub-b")" "$sha_b_before"
}

# ---------------------------------------------------------------------------
# Test 4: one uninitialized submodule ('-' prefix) → gets populated
# ---------------------------------------------------------------------------
@test "uninitialized submodule gets populated" {
    local child_remote="$BATS_TEST_TMPDIR/child-remote.git"
    local parent_remote="$BATS_TEST_TMPDIR/parent-remote.git"
    local gitrepo="$BATS_TEST_TMPDIR/repo"

    create_bare_remote "$child_remote"
    create_bare_remote_with_child_submodule "$parent_remote" "$child_remote"

    # To avoid fumbling with de-init of submodules etc. we mimic the behavior
    # we want to guard-rail against: cloning a repository with submodules
    # but without initializing and update, or cloning recursive.
    # We first need to push the changes to remote, then throw away
    # the repository clone and clone again.

    run git clone "$parent_remote" "$gitrepo"
    cd "$gitrepo"

    # Confirm the directory is empty / uninitialized before running
    run git -C "$gitrepo" submodule status
    assert_output --regexp '^-[0-9a-f]{5,40} child$'

    run bash "${SCRIPT_UNDER_TEST}"
    assert_success
    # All cases should include a small foot-print of the script was running:
    assert_output --partial "ensure-submodules-populated: found 1 uninitialized submodule(s), populating..."
    assert_output --partial "populating submodule: child"
    assert_output --partial "ensure-submodules-populated: done"

    run git -C "$gitrepo" submodule status
    assert_output --regexp '^ [0-9a-f]{5,40} child.*'

    # Submodule directory must now be non-empty (contains .git file)
    # NOTICE 'child' is from internal details of the method 'create_bare_remote_with_child_submodule'
    assert [ -e "$gitrepo/child/.git" ]
}

# ---------------------------------------------------------------------------
# Test 5: submodule at different SHA ('+' prefix) → not touched
# ---------------------------------------------------------------------------
@test "submodule at different SHA is not touched" {
    local remote="$BATS_TEST_TMPDIR/remote.git"
    local gitrepo="$BATS_TEST_TMPDIR/repo"

    create_bare_remote "$remote"
    create_gitrepo "$gitrepo"
    add_submodule_to_gitrepo "$gitrepo" "$remote" "sub"

    mark_submodule_at_different_sha "$gitrepo" "sub"

    local sha_before
    sha_before=$(submodule_sha "$gitrepo" "sub")

    # Confirm '+' prefix is present before running
    run git -C "$gitrepo" submodule status
    assert_output --partial "+"

    cd "$gitrepo"
    run bash "${SCRIPT_UNDER_TEST}"
    assert_success
    # All cases should include a small foot-print of the script was running:
    assert_output --partial "ensure-submodules-populated: all git submodules are already initialized, skipping"

    # SHA must be unchanged – script must not have touched this submodule
    assert_equal "$(submodule_sha "$gitrepo" "sub")" "$sha_before"
}

# ---------------------------------------------------------------------------
# Test 6: mixed – uninitialized submodule gets populated, '+' submodule left alone
# ---------------------------------------------------------------------------
@test "mixed: uninit submodule populated, different-SHA submodule unchanged" {
    local remote_a="$BATS_TEST_TMPDIR/remote-a.git"
    local remote_b="$BATS_TEST_TMPDIR/remote-b.git"
    local gitrepo="$BATS_TEST_TMPDIR/repo"

    create_bare_remote "$remote_a"
    create_bare_remote "$remote_b"
    create_gitrepo "$gitrepo"
    add_submodule_to_gitrepo "$gitrepo" "$remote_a" "sub-a"
    add_submodule_to_gitrepo "$gitrepo" "$remote_b" "sub-b"

    # sub-a → uninitialised ('-')
    mark_submodule_uninitialized "$gitrepo" "sub-a"
    # sub-b → local commit ahead ('+')
    mark_submodule_at_different_sha "$gitrepo" "sub-b"

    local sha_b_before
    sha_b_before=$(submodule_sha "$gitrepo" "sub-b")

    cd "$gitrepo"
    run bash "${SCRIPT_UNDER_TEST}"
    assert_success
    # All cases should include a small foot-print of the script was running:
    assert_output --partial "ensure-submodules-populated: found 1 uninitialized submodule(s), populating..."
    assert_output --partial "populating submodule: sub-a"
    assert_output --partial "ensure-submodules-populated: done"

    # sub-a must now be populated
    assert [ -e "$gitrepo/sub-a/.git" ]

    # sub-b SHA must be unchanged
    assert_equal "$(submodule_sha "$gitrepo" "sub-b")" "$sha_b_before"
}

# ---------------------------------------------------------------------------
# Test 7: nested submodules – parent uninitialized → both parent and nested
#          child are populated (proves --recursive behaviour)
# ---------------------------------------------------------------------------
@test "nested submodules: parent and child both populated when parent is uninitialized" {
    local child_remote="$BATS_TEST_TMPDIR/child-remote.git"
    local parent_remote="$BATS_TEST_TMPDIR/parent-remote.git"
    local gitrepo="$BATS_TEST_TMPDIR/repo"

    create_bare_remote "$child_remote"
    create_bare_remote_with_child_submodule "$parent_remote" "$child_remote"
    create_gitrepo "$gitrepo"
    add_submodule_to_gitrepo "$gitrepo" "$parent_remote" "parent"

    mark_submodule_uninitialized "$gitrepo" "parent"

    cd "$gitrepo"
    run bash "${SCRIPT_UNDER_TEST}"
    assert_success

    # Parent must be populated
    assert [ -e "$gitrepo/parent/.git" ]

    # Nested child inside parent must also be populated
    assert [ -e "$gitrepo/parent/child/.git" ]
}
