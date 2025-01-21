# STM32 + CMake + Docker + CI

[![CI Pipeline Status](https://github.com/the-risk-taker/stm32-cmake-static-analysis-docker-and-ci/actions/workflows/ci-pipeline.yml/badge.svg?branch=main)](https://github.com/the-risk-taker/stm32-cmake-static-analysis-docker-and-ci/actions/workflows/ci-pipeline.yml)

Template project demonstrating how to use CMake with STM32CubeMX-generated code. Build and flash your STM32 project with just three commands. Includes Docker support and GitHub Actions CI pipeline.

## Prerequisites

### Local Development

Required tools (must be in PATH):

- [Arm GNU Toolchain](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads)
- [STM32CubeProgrammer](https://www.st.com/en/development-tools/stm32cubeprog.html)
- CMake 3.x
- Ninja

### Docker Development

> [!TIP]
> Use pre-built Docker image: [therisktaker/arm-none-eabi-14.2-and-tools](https://hub.docker.com/repository/docker/therisktaker/arm-none-eabi-14.2-and-tools/general).

## Quick Start

Configure project:

```shell
cmake -DCMAKE_TOOLCHAIN_FILE=cmake/arm-none-eabi-gcc.cmake -DCMAKE_BUILD_TYPE=Release -S . -B build -G Ninja
```

Build project:

```shell
ninja -C build
```

Flash to device:

```shell
ninja -C build program
```

## Static Analysis

Run Cppcheck (must be in PATH):

```shell
ninja -C build cppcheck-check
```

## References

- [CMake Cross-Platform Guide](https://stackoverflow.com/a/43836115)
- [NUCLEO-L476RG Documentation](https://www.st.com/en/evaluation-tools/nucleo-l476rg.html)
