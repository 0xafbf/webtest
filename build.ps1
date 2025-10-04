

$SCRIPT_ROOT = $PSScriptRoot
$EMSDK_PATH = "$SCRIPT_ROOT/../emsdk"
$ODIN_PATH = "$SCRIPT_ROOT/../odin"

& "$EMSDK_PATH/emsdk_env.ps1"

# for compiling with odin compiler
# problem is: it won't find functions like "emscripten_cancel_main_loop"
# & "$ODIN_PATH/odin.exe" build src -target:js_wasm32 -show-system-calls -extra-linker-flags:./libSDL3.a -define:SDL3_WASM_LIB="c:/abotero/webtest/libsdl3.o"

echo "compiling"
& "$ODIN_PATH/odin.exe" build src -target:js_wasm32 -show-system-calls -define:SDL3_WASM_LIB="c:/abotero/webtest/libsdl3.o" -build-mode:obj -out:game.wasm.o

echo "linking"
emcc -o index.html .\game.wasm.o .\libSDL3.a --shell-file .\index_template.html -sERROR_ON_UNDEFINED_SYMBOLS=0 -g
