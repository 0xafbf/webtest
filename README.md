Findings:

Odin doesn't include Emscripten when building to WASM

- Emscripten is a reimplementation of libc for the browser
- SDL has support for Emscripten out of the box

SDL doesn't work when compiled against WASM without emscripten

Option 1: Make SDL work without emscripten
Option 2: Include emscripten in web build

Check this:
https://github.com/karl-zylinski/odin-raylib-web/blob/main/build_web.sh



Steps I tried so far:
```
# run from repo directory
source ../emsdk/emsdk_env.sh
# or in windows
../emsdk/emsdk_env.ps1

cd ../SDL/
mkdir webbuild; cd webbuild
emcmake cmake ..
emmake make # or ninja

cp .\libSDL3.a .\libSDL3.o
..\odin\odin.exe build src -target:js_wasm32 -define:SDL3_WASM_LIB="c:/abotero/webtest/libsdl3.o"


..\odin\odin.exe build src -target:js_wasm32 -build-mode:obj

..\odin\odin.exe build src -target:js_wasm32 -define:SDL3_WASM_LIB="c:/abotero/webtest/libsdl3.o" -build-mode:obj
..\odin\odin.exe build src -target:js_wasm32 -define:SDL3_WASM_LIB="c:/abotero/webtest/libsdl3.o" -build-mode:obj -out:src.wasm.o

emcc .\src.wasm.o .\libSDL3.a -o src.wasm



odin build source/main_web -target:js_wasm32 -build-mode:obj -define:RAYLIB_WASM_LIB=env.o -define:RAYGUI_WASM_LIB=env.o -vet -strict-style -out:$OUT_DIR/game.wasm.o



```



For now, it seems if I try to compile with js_wasm32, odin compiler will emit a
_start function, but when linking with emscripten it will fail because
emscripten also exports a _start function

Possible ways through this:

- link libsdl within the odin compiler
```
..\odin\odin.exe build src -target:js_wasm32 -show-system-calls -extra-linker-flags:./libSDL3.a -define:SDL3_WASM_LIB="c:/abotero/webtest/libsdl3.o"
```
The problem with this is that libsdl requires emscripten

- compile odin code to target freestanding wasm32, and trust emscripten/sdl entry point

