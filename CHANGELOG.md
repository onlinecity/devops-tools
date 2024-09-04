# Changelog

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
