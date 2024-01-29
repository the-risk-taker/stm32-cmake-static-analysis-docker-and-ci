cmake_minimum_required(VERSION 3.20)

project(stm32-and-cmake)
enable_language(ASM)

if (${CMAKE_CXX_COMPILER_ID} STREQUAL "GNU")
    add_compile_options (-fdiagnostics-color=always)
elseif (${CMAKE_CXX_COMPILER_ID} STREQUAL "Clang")
    add_compile_options (-fcolor-diagnostics)
endif ()

# Variables
include(cmake/constants.cmake)

set(MCPU                     ${MCPU_CORTEX_M4})
set(MFPU                     ${MFPU_FPV5_D16})
set(MFLOAT_ABI               ${MFLOAT_ABI_HARDWARE})
set(RUNTIME_LIBRARY          ${RUNTIME_LIBRARY_REDUCED_C})
set(RUNTIME_LIBRARY_SYSCALLS ${RUNTIME_LIBRARY_SYSCALLS_MINIMAL})
set(LINKER_SCRIPT            ${CMAKE_SOURCE_DIR}/STM32L476RGTX_FLASH.ld)

# Flags
set(COMPILER_FLAGS "${MCPU} ${MFPU} ${MFLOAT_ABI} ${RUNTIME_LIBRARY} -Wall -Werror -ffunction-sections -fdata-sections -fstack-usage -MMD -MP -mthumb")
add_compile_definitions(STM32L476xx=1)

set(CMAKE_C_FLAGS   "${COMPILER_FLAGS} -std=c2x")
set(CMAKE_CXX_FLAGS "${COMPILER_FLAGS} -std=c++20")
set(CMAKE_ASM_FLAGS "${CMAKE_C_FLAGS} -x assembler-with-cpp")
set(CMAKE_EXE_LINKER_FLAGS "-T${LINKER_SCRIPT} ${RUNTIME_LIBRARY_SYSCALLS} -Wl,-Map=${PROJECT_NAME}.map -Wl,--gc-sections -static -Wl,--start-group -lc -lm -Wl,--end-group")
set(CMAKE_EXECUTABLE_SUFFIX ".elf")

# HAL
add_subdirectory(Drivers)

# App
set(APP_SOURCES
    app/main.cpp
)

set(SUPPORT_SOURCES
    Core/Src/stm32l4xx_hal_msp.c
    Core/Src/stm32l4xx_it.c
    Core/Src/syscalls.c
    Core/Src/sysmem.c
    Core/Src/system_stm32l4xx.c
)

add_executable(${PROJECT_NAME} ${APP_SOURCES} ${SUPPORT_SOURCES} Core/Startup/startup_stm32l476rgtx.s)
target_include_directories(${PROJECT_NAME} PRIVATE Core/Inc)
target_link_libraries(${PROJECT_NAME} PRIVATE STM_HAL)

add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD COMMAND ${CMAKE_SIZE} $<TARGET_FILE:${PROJECT_NAME}>)

# Programming target
find_program(STM32_PROGRAMMER_CLI STM32_Programmer_CLI)
if(STM32_PROGRAMMER_CLI)
    message(STATUS "STM32_Programmer_CLI was found, 'program' target can be used")
    add_custom_target(program DEPENDS ${PROJECT_NAME} COMMAND ${STM32_PROGRAMMER_CLI} --connect port=SWD --write $<TARGET_FILE:${PROJECT_NAME}> --verify -rst)
else()
    message(STATUS "STM32_Programmer_CLI was not found, program target is inaccessible")
endif()
