# devbox base-config plugin tests

This is just a proof-of-concept, as mentioned the [repository root README](../../../README.md).

Overview of tests, possible further test specific details and implementation details in subsections below.

| Test name | Description |
| --- | --- |
| `ensure-submodules-populated.bats` | Verifies the shell script that is called in the plugin init hook, to detect uninitialized git submodules of a project and initializes the with content, to guard rail against other tools that do not automatically detect or warn about missing contents and acts as nothing is wrong (_Looking angry a you Ansible!_). |
