cmake_minimum_required(VERSION 3.20)
project(stm32-and-cmake LANGUAGES C CXX ASM)

set(CMAKE_COLOR_DIAGNOSTIC ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# PROJECT FLAGS
include(cmake/constants.cmake)
set(MCPU                     ${MCPU_CORTEX_M4})
set(MFPU                     ${MFPU_FPV5_D16})
set(MFLOAT_ABI               ${MFLOAT_ABI_HARDWARE})
set(RUNTIME_LIBRARY          ${RUNTIME_LIBRARY_REDUCED_C})
set(RUNTIME_LIBRARY_SYSCALLS ${RUNTIME_LIBRARY_SYSCALLS_MINIMAL})
set(LINKER_SCRIPT            ${CMAKE_SOURCE_DIR}/STM32L476RGTX_FLASH.ld)

set(COMPILER_FLAGS "${MCPU} ${MFPU} ${MFLOAT_ABI} ${RUNTIME_LIBRARY} -Wall -Werror -ffunction-sections -fdata-sections -fstack-usage -MMD -MP -mthumb")
set(CMAKE_C_FLAGS   "${COMPILER_FLAGS} -std=c2x")
set(CMAKE_CXX_FLAGS "${COMPILER_FLAGS} -std=c++20")
set(CMAKE_ASM_FLAGS "${CMAKE_C_FLAGS} -x assembler-with-cpp")
set(CMAKE_EXE_LINKER_FLAGS "-T${LINKER_SCRIPT} ${RUNTIME_LIBRARY_SYSCALLS} -Wl,-Map=${PROJECT_NAME}.map -Wl,--gc-sections -static -Wl,--start-group -lc -lm -Wl,--end-group")
set(CMAKE_EXECUTABLE_SUFFIX ".elf")

add_compile_definitions(STM32L476xx=1)

# HAL
add_subdirectory(Drivers)

# APP
add_subdirectory(app)

# PROGRAMMING TARGET
find_program(STM32_PROGRAMMER_CLI STM32_Programmer_CLI)
if(STM32_PROGRAMMER_CLI)
    message(STATUS "STM32_Programmer_CLI was found, 'program' target can be used")
    add_custom_target(program DEPENDS ${PROJECT_NAME} COMMAND ${STM32_PROGRAMMER_CLI} --connect port=SWD --write $<TARGET_FILE:${PROJECT_NAME}> --verify -rst)
else()
    message(STATUS "STM32_Programmer_CLI was not found, program target is inaccessible")
endif()

# CPCHECK
include(cmake/cppcheck.cmake)
