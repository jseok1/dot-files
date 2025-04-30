#!/bin/bash

# Run this on MSYS2 when running clangd from WSL2.
#
# Also, remember to use a conan profile with ninja.
# $ conan install . --profile=release-gcc

DEBUG=false
GENERATE=false
COMPILE_COMMANDS_PATH="build/Release/compile_commands.json"

for arg in "$@"; do
    if [[ "$arg" == "--debug" ]]; then
        DEBUG=true
        COMPILE_COMMANDS_PATH="build/Debug/compile_commands.json"
    fi

    if [[ "$arg" == "--generate" ]]; then
        GENERATE=true
    fi
done

if $GENERATE; then
    if $DEBUG; then
        cmake --preset conan-debug
    else
        cmake --preset conan-release
    fi

    # C:\\... → /mnt/c/...
    sed -i "s/C:/\/mnt\/c/g; s/\\\\\\\\/\//g" $COMPILE_COMMANDS_PATH
fi

if $DEBUG; then
    cmake --build --preset conan-debug
else
    cmake --build --preset conan-release
fi

# TODO: Should I make this my own script and add an alias?
# Or do something crazy like intercept cmake
# OR just have this as another command to run in addition to cmake --preset conan-release and have lua refresh clangd, if needed
