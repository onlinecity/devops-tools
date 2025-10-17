# Changelog

## [3.4.2](https://github.com/onlinecity/devops-tools/compare/v3.4.1...v3.4.2) (2025-10-17)


### Bug Fixes

* release-please.yml from templates not valid yaml ([#58](https://github.com/onlinecity/devops-tools/issues/58)) ([c29e560](https://github.com/onlinecity/devops-tools/commit/c29e5600c85ab4406c517e77e904494cf196849b))

## [3.4.1](https://github.com/onlinecity/devops-tools/compare/v3.4.0...v3.4.1) (2025-10-16)


### Bug Fixes

* Remove comments from JSON files for release-please ([#57](https://github.com/onlinecity/devops-tools/issues/57)) ([43f5ff7](https://github.com/onlinecity/devops-tools/commit/43f5ff70893431366ec2734639ee5517f48da22d))
* Remove dependabot bootstrap (moved to github-infrastruture) ([#55](https://github.com/onlinecity/devops-tools/issues/55)) ([c38fe96](https://github.com/onlinecity/devops-tools/commit/c38fe96c8e6791142e207244cfae5284c6ece8f2))

## [3.4.0](https://github.com/onlinecity/devops-tools/compare/v3.3.0...v3.4.0) (2025-08-15)


### Features

* Add dnspython for community.general.dig lookup ([95c19d9](https://github.com/onlinecity/devops-tools/commit/95c19d96ba8f47295d887ed97ab9066ede377c96))
* Add dnspython for community.general.dig lookup ([#54](https://github.com/onlinecity/devops-tools/issues/54)) ([39becb4](https://github.com/onlinecity/devops-tools/commit/39becb4d2233c629e200cf5e56155f4e3d7213f3))


### Bug Fixes

* Update release-please command to new workflow ([#52](https://github.com/onlinecity/devops-tools/issues/52)) ([6b5057d](https://github.com/onlinecity/devops-tools/commit/6b5057db8ddee9ffb9086237b2f7391522cb38e2))

## [3.3.0](https://github.com/onlinecity/devops-tools/compare/v3.2.0...v3.3.0) (2025-07-16)


### Features

* ensure git submodules are not empty ([#50](https://github.com/onlinecity/devops-tools/issues/50)) ([d5c9381](https://github.com/onlinecity/devops-tools/commit/d5c9381f189544bb8c4d12dac02bc3184b496c33))

## [3.2.0](https://github.com/onlinecity/devops-tools/compare/v3.1.2...v3.2.0) (2025-07-11)


### Features

* add glcoud auth Pip package for Ansible ([#48](https://github.com/onlinecity/devops-tools/issues/48)) ([2061ac3](https://github.com/onlinecity/devops-tools/commit/2061ac3cbaaef335929f6fff7959ff4de8e770ca))

## [3.1.2](https://github.com/onlinecity/devops-tools/compare/v3.1.1...v3.1.2) (2025-07-08)


### Bug Fixes

* use go template escape in release please file ([#46](https://github.com/onlinecity/devops-tools/issues/46)) ([092f80f](https://github.com/onlinecity/devops-tools/commit/092f80fbce9c8ef3ebaa10e9374abca7889d35be))

## [3.1.1](https://github.com/onlinecity/devops-tools/compare/v3.1.0...v3.1.1) (2025-07-08)


### Bug Fixes

* release please use new action path and config ([#44](https://github.com/onlinecity/devops-tools/issues/44)) ([9a14ce3](https://github.com/onlinecity/devops-tools/commit/9a14ce3ecb3e3e8910560085a60e62522bb227ff))

## [3.1.0](https://github.com/onlinecity/devops-tools/compare/v3.0.1...v3.1.0) (2025-06-23)


### Features

* Setup ansible factcache ([#42](https://github.com/onlinecity/devops-tools/issues/42)) ([d77efcf](https://github.com/onlinecity/devops-tools/commit/d77efcf126091b8dd27435e370edaa3029b6e2ed))

## [3.0.1](https://github.com/onlinecity/devops-tools/compare/v3.0.0...v3.0.1) (2025-06-17)


### Bug Fixes

* Release please ;-) ([5eedb0a](https://github.com/onlinecity/devops-tools/commit/5eedb0aa70696a8c71ffa84ebd0dcdcc3f67d35e))

## [3.0.0](https://github.com/onlinecity/devops-tools/compare/v2.2.0...v3.0.0) (2025-02-21)


### ⚠ BREAKING CHANGES

* Use opentofu in ssh write config files ([#38](https://github.com/onlinecity/devops-tools/issues/38))

### Features

* Use opentofu in ssh write config files ([#38](https://github.com/onlinecity/devops-tools/issues/38)) ([19335e3](https://github.com/onlinecity/devops-tools/commit/19335e37e921d4db9d59aa2ce46f681e89cc98b0))

## [2.2.0](https://github.com/onlinecity/devops-tools/compare/v2.1.2...v2.2.0) (2025-02-10)


### Features

* Adding helm and helm lint pre-commit hook ([#35](https://github.com/onlinecity/devops-tools/issues/35)) ([993d565](https://github.com/onlinecity/devops-tools/commit/993d565e65c503839843e3afa70da8ee81e36b49))


### Bug Fixes

* set proper permissions on ssh config files ([#36](https://github.com/onlinecity/devops-tools/issues/36)) ([db456f7](https://github.com/onlinecity/devops-tools/commit/db456f72be7576063189b3914ad0c8170b90950e))

## [2.1.2](https://github.com/onlinecity/devops-tools/compare/v2.1.1...v2.1.2) (2024-09-25)


### Bug Fixes

* Ensure .editorconfig is added for pre-commit ([#33](https://github.com/onlinecity/devops-tools/issues/33)) ([ce07512](https://github.com/onlinecity/devops-tools/commit/ce0751250b38c35a646b2becb367183e704d2a6a))

## [2.1.1](https://github.com/onlinecity/devops-tools/compare/v2.1.0...v2.1.1) (2024-09-04)


### Bug Fixes

* improve alias script for terraform/tofu ([#30](https://github.com/onlinecity/devops-tools/issues/30)) ([88628ef](https://github.com/onlinecity/devops-tools/commit/88628ef927549686e0f1752c08c5265ece3f9d4d))

## [2.1.0](https://github.com/onlinecity/devops-tools/compare/v2.0.0...v2.1.0) (2024-08-13)


### Features

* Include editorconfig in pre-commit and support CI ([#28](https://github.com/onlinecity/devops-tools/issues/28)) ([584229a](https://github.com/onlinecity/devops-tools/commit/584229aa84d133a48cca7860263711c0864b836b))

## [2.0.0](https://github.com/onlinecity/devops-tools/compare/v1.6.1...v2.0.0) (2024-08-12)


### ⚠ BREAKING CHANGES

* Migration command available to clean up old Python dependencies applied by version 1x of our devbox base plugin.

### Features

* Add bootstrap support editorconfig ([#25](https://github.com/onlinecity/devops-tools/issues/25)) ([881d9be](https://github.com/onlinecity/devops-tools/commit/881d9be11b2563b97ba462c372df3e84ffe1e041))
* Adding "aliases" support including terraform/tofu check ([#23](https://github.com/onlinecity/devops-tools/issues/23)) ([49e13d1](https://github.com/onlinecity/devops-tools/commit/49e13d12b08319a342bb1f8406ee368dd9618dc5))
* Move devbox/taskfile requirements scope ([#26](https://github.com/onlinecity/devops-tools/issues/26)) ([64eb249](https://github.com/onlinecity/devops-tools/commit/64eb2498051d395dedbd36a1315d61c8a436fe31))

## [1.6.1](https://github.com/onlinecity/devops-tools/compare/v1.6.0...v1.6.1) (2024-07-04)


### Bug Fixes

* Add about Python req. and fix ansible-bootstrap ([#22](https://github.com/onlinecity/devops-tools/issues/22)) ([cceed1f](https://github.com/onlinecity/devops-tools/commit/cceed1fbd9d467e5a2a1ec20cf973829e6575b9b))
* Explicitly install devbox python requirements in init-hook ([5c5dd06](https://github.com/onlinecity/devops-tools/commit/5c5dd06578547389ba9c2792787f2f5617e80a3d))
* Fix wording in ansible.cfg.dist regarding collections_path ([2905f22](https://github.com/onlinecity/devops-tools/commit/2905f226fdba6fc51a834a00bb3ead6f49860635))

## [1.6.0](https://github.com/onlinecity/devops-tools/compare/v1.5.1...v1.6.0) (2024-07-04)


### Features

* Add devbox task, and default requirements.txt file ([#19](https://github.com/onlinecity/devops-tools/issues/19)) ([d675265](https://github.com/onlinecity/devops-tools/commit/d6752651227113f92592be2374dbe825446d9687))

## [1.5.1](https://github.com/onlinecity/devops-tools/compare/v1.5.0...v1.5.1) (2024-06-10)


### Bug Fixes

* Git ignore .venv always ([#15](https://github.com/onlinecity/devops-tools/issues/15)) ([3689216](https://github.com/onlinecity/devops-tools/commit/36892162b51a51791653b7a0e29841bd38c5bd1b))

## [1.5.0](https://github.com/onlinecity/devops-tools/compare/v1.4.0...v1.5.0) (2024-06-07)


### Features

* make minor release ([7f482ff](https://github.com/onlinecity/devops-tools/commit/7f482ff7ba4e6da4b6f861ed505963dce3bb42fe))

## [1.4.0](https://github.com/onlinecity/devops-tools/compare/v1.3.0...v1.4.0) (2024-06-06)


### Features

* Only use py virt env if requirements file exists ([#14](https://github.com/onlinecity/devops-tools/issues/14)) ([51bfe53](https://github.com/onlinecity/devops-tools/commit/51bfe53e620a875ac6bb673ef6292a918193a5ba))
* Tofu support ([#12](https://github.com/onlinecity/devops-tools/issues/12)) ([50f0e5f](https://github.com/onlinecity/devops-tools/commit/50f0e5feee1575610ced7fda0513e276db42515a))


### Bug Fixes

* Move Python virt. env to standard non devbox path ([#11](https://github.com/onlinecity/devops-tools/issues/11)) ([8666be6](https://github.com/onlinecity/devops-tools/commit/8666be6e0e109276e76732a56fce20cf1116c49f))

## [1.3.0](https://github.com/onlinecity/devops-tools/compare/v1.2.2...v1.3.0) (2024-05-29)


### Features

* release ansible config feat ([a80d485](https://github.com/onlinecity/devops-tools/commit/a80d485db2e8731dcaaeeed6b87ee1a6f9469085))

## [1.2.2](https://github.com/onlinecity/devops-tools/compare/v1.2.1...v1.2.2) (2024-05-23)


### Bug Fixes

* Changed task ansible-galaxy to run in current dir ([ce82171](https://github.com/onlinecity/devops-tools/commit/ce8217163444738742336326ea1c074dd76b9663))
* Fixed bug ([7c7991b](https://github.com/onlinecity/devops-tools/commit/7c7991b05d6e4525807d59cd07fb96a77f276e00))

## [1.2.1](https://github.com/onlinecity/devops-tools/compare/v1.2.0...v1.2.1) (2024-05-21)


### Bug Fixes

* Adding yamlint config file ([5de69fb](https://github.com/onlinecity/devops-tools/commit/5de69fba900511e3219247e70de5f00f1c288caa))

## [1.2.0](https://github.com/onlinecity/devops-tools/compare/v1.1.0...v1.2.0) (2024-05-21)


### Features

* Add release-please bootstrapping ([1298e24](https://github.com/onlinecity/devops-tools/commit/1298e24ab2e3b895e42953b8efddb97afeee5ad8))
* Add taskfile setup ([#4](https://github.com/onlinecity/devops-tools/issues/4)) ([3cf6b16](https://github.com/onlinecity/devops-tools/commit/3cf6b1662f333737bd52ae438216d272c73c96b8))


### Bug Fixes

* Missing file ([0336a22](https://github.com/onlinecity/devops-tools/commit/0336a225efa32889fb7e78f1955709a1854d473a))

## [1.1.0](https://github.com/onlinecity/devops-tools/compare/v1.0.0...v1.1.0) (2024-04-23)


### Features

* Adding bootstrap scripts ([#2](https://github.com/onlinecity/devops-tools/issues/2)) ([9ee93f5](https://github.com/onlinecity/devops-tools/commit/9ee93f52e4f1f0ec587e58ce034c583f6f980e75))

## 1.0.0 (2024-04-22)


### Features

* Adding base-config plugin ([1e815e2](https://github.com/onlinecity/devops-tools/commit/1e815e2d21bd20dbefe5cd8d202a3a35c0bd0d71))


### Bug Fixes

* Adding release please ([a02a64b](https://github.com/onlinecity/devops-tools/commit/a02a64b844088c5ce003a11b6894fed20398b9f3))
