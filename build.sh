#! /bin/bash
# Copyright Andrés Botero 2025
#
set -ex

# first ensure that you have:
#  - clang
#  - odin
#  - cmake
#  - emsdk install latest
#  - source emsdk_env
#  - clone https://github.com/libsdl-org/SDL.git
#  - cd SDL && git checkout release-3.2.24
#

SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ODIN_PATH="$SCRIPT_PATH/../odin"
SDL_PATH="$SCRIPT_PATH/../SDL"

# git clone emsdk
# ./emsdk install latest
# ./emsdk activate latest
# you don't need to source emsdk_env as we do here manually
EMSDK_PATH="$SCRIPT_PATH/../emsdk"



# ensure that SDL is built for web
BUILD_PATH="./build"
PREFIX_PATH="./prefix"

SDL_LIBRARY="./libSDL3.a"

if [ ! -e "$BUILD_PATH/sdl/libSDL3.a" ]; then

    mkdir -p "$BUILD_PATH/sdl"
    pushd "$BUILD_PATH/sdl"

    if [ -z "$EMSDK" ]; then
        echo "Loading emsdk environment"
        source "$EMSDK_PATH/emsdk_env.sh"
    fi
    emcmake cmake "$SDL_PATH"
    make "-j$(nproc)"
    popd
fi

echo "Compiling"

"$ODIN_PATH/odin" build src \
    -target:js_wasm32 \
    -build-mode:obj \
    -debug \
    -out:game.wasm.o \
#    -show-system-calls \


echo "Linking"

if [ -z "$EMSDK" ]; then
    echo "Loading emsdk environment"
    source "$EMSDK_PATH/emsdk_env.sh"
fi

emcc \
    -o "index.html" \
    "game.wasm.o" \
    "$BUILD_PATH/sdl/libSDL3.a" \
    --shell-file "index_template.html" \
    -sERROR_ON_UNDEFINED_SYMBOLS=0 \
    -sFETCH \
    -g

