
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


# build with odin, link with emcc
..\odin\odin.exe build src -target:js_wasm32 -define:SDL3_WASM_LIB="c:/abotero/webtest/libsdl3.o" -build-mode:obj -out:src.wasm.o -define:AB_ENTRY_POINT=true
emcc .\src.wasm.o .\libSDL3.a -o src.wasm

# build all with odin
..\odin\odin.exe build src -target:js_wasm32 -define:SDL3_WASM_LIB="c:/abotero/webtest/libsdl3.o" 


# run wasm-objdump -x "<filename>" | grep "_start" over every file in current folder and tell me what file matches
for f in *; do
    if wasm-objdump -x "$f" 2>/dev/null | grep -q '"_start"'; then
        echo "Match found in: $f"
    fi
done

odin build source/main_web -target:js_wasm32 -build-mode:obj -define:RAYLIB_WASM_LIB=env.o -define:RAYGUI_WASM_LIB=env.o -vet -strict-style -out:$OUT_DIR/game.wasm.o



..\odin\odin.exe build src -target:freestanding_wasm32
..\odin\odin.exe build src -target:freestanding_wasm32 -define:AB_FREESTANDING=true



PS C:\abotero\webtest> ..\odin\odin.exe build src -target:freestanding_wasm32
PS C:\abotero\webtest> ..\odin\odin.exe build src -target:freestanding_wasm32 -define:SDL3_WASM_LIB="c:/abotero/webtest/libsdl3.o" -build-mode:obj -out:src.wasm.o                      
PS C:\abotero\webtest> ..\odin\odin.exe build src -target:freestanding_wasm32 -build-mode:obj -out:src.wasm.o                                                                           
PS C:\abotero\webtest> rm .\src.wasm.o                                                                                                                                                  
PS C:\abotero\webtest> ..\odin\odin.exe build src -target:freestanding_wasm32 -build-mode:obj -out:src.wasm.o 
emcc .\src.wasm.o .\libSDL3.a -o src.wasm

-show-system-calls
-print-linker-flags
-extra-linker-flags:arstrast

        -build-mode:<mode>
                Sets the build mode.
                Available options:
                        -build-mode:exe         Builds as an executable.
                        -build-mode:test        Builds as an executable that executes tests.
                        -build-mode:dll         Builds as a dynamically linked library.
                        -build-mode:shared      Builds as a dynamically linked library.
                        -build-mode:dynamic     Builds as a dynamically linked library.
                        -build-mode:lib         Builds as a statically linked library.
                        -build-mode:static      Builds as a statically linked library.
                        -build-mode:obj         Builds as an object file.
                        -build-mode:object      Builds as an object file.
                        -build-mode:assembly    Builds as an assembly file.
                        -build-mode:assembler   Builds as an assembly file.
                        -build-mode:asm         Builds as an assembly file.
                        -build-mode:llvm-ir     Builds as an LLVM IR file.
                        -build-mode:llvm        Builds as an LLVM IR file.
