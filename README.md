Findings:

Odin doesn't include Emscripten when building to WASM

- Emscripten is a reimplementation of libc for the browser
- SDL has support for Emscripten out of the box

SDL doesn't work when compiled against WASM without emscripten

Option 1: Make SDL work without emscripten
Option 2: Include emscripten in web build

Check this:
https://github.com/karl-zylinski/odin-raylib-web/blob/main/build_web.sh

