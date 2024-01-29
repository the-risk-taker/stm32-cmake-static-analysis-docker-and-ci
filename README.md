# STM32 + CMake + Docker + CI

[![.github/workflows/ci-pipeline.yml](https://github.com/the-risk-taker/stm32-cmake-static-analysis-docker-and-ci/actions/workflows/ci-pipeline.yml/badge.svg?branch=main)](https://github.com/the-risk-taker/stm32-cmake-static-analysis-docker-and-ci/actions/workflows/ci-pipeline.yml)

Porting project generated with STM32CubeMX to CMake. The idea is to `setup`, `build` and `flash` the program using `only three commands`. Tested on [NUCLEO-L476RG](https://www.st.com/en/evaluation-tools/nucleo-l476rg.html).

Good reference on how to writing CMake for cross-platform development can be found [here](https://stackoverflow.com/a/43836115).

## Requirements

- [Arm GNU Toolchain](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads)
- [STM32CubeProgrammer](https://www.st.com/en/development-tools/stm32cubeprog.html)
- CMake
- Ninja

Tools must be in PATH. Or build ready to use Docker image from [Dockerfile](Dockerfile).

## Setup, building and programming

Setup project by calling:

```shell
cmake -DCMAKE_TOOLCHAIN_FILE=cmake/arm-none-eabi-gcc.cmake -DCMAKE_BUILD_TYPE=Release -S . -B build -G Ninja
```

Build project:

```shell
ninja -C build
```

Flash the program:

```shell
ninja -C build program
```

## Static analysis

Make sure that `Cppcheck 2.13.0` is installed and in PATH, then to check code with Cppcheck call:

```shell
ninja -C build cppcheck-check
```
