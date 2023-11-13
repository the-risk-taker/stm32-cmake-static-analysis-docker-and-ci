# STM32 & CMake

Porting project generated with STM32CubeMX to CMake. The idea is to `setup`, `build` and `flash` the program using `only three commands`. Tested on [NUCLEO-L476RG](https://www.st.com/en/evaluation-tools/nucleo-l476rg.html).

Good reference on how to writing CMake for cross-platform development can be found [here](https://stackoverflow.com/a/43836115).

## Requirements

- [Arm GNU Toolchain](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads)
- [STM32CubeProgrammer](https://www.st.com/en/development-tools/stm32cubeprog.html)
- CMake
- Ninja

Tools must be in PATH.

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
