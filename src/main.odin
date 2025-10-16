
package main


import SDL "vendor:sdl3"
import IMG "vendor:sdl3/image"
import TTF "vendor:sdl3/ttf"

import "core:fmt"
import "core:c"
// import "core:os"
import "core:image"
import "core:image/jpeg"

import "base:runtime"

import "emscripten"

ctx: runtime.Context


window: ^SDL.Window
renderer: ^SDL.Renderer
texture: ^SDL.Texture
texture_size: [2]i32
engine: ^TTF.TextEngine


// @(export) emscripten_cancel_main_loop :: proc "c" () {

// }
// @(export) abort :: proc "c" () {

// }
@export
main_start :: proc "c" () {

    sdl_app_init(nil, 0, nil)


//    request_data("/sample.jpg")
    fetch_attr := emscripten.emscripten_fetch_attr_t {}
    emscripten.emscripten_fetch_attr_init(&fetch_attr)
    fetch_attr.onsuccess = fetch_success
    fetch_attr.attributes = emscripten.EMSCRIPTEN_FETCH_LOAD_TO_MEMORY
    emscripten.emscripten_fetch(&fetch_attr, "/sample.jpg")
}


fetch_success :: proc "c" (result: ^emscripten.emscripten_fetch_t) {
    context = ctx

    data: [^]byte = ([^]byte)(result.data)
    size: int = (int)(result.numBytes)
    if size == 0 {
       return
    }

    bytes := data[0:size]
    image, err := image.load_from_bytes(bytes)

    io := SDL.IOFromConstMem(data, uint(size))
    texture = IMG.LoadTexture_IO(renderer, io, false)

}

/*
request_data(url: cstring, callback: proc(bytes: []byte)) {

}
*/

@export
main_update :: proc "c" () -> bool {
    return sdl_app_iterate(nil) == .CONTINUE
}

@export
main_end :: proc "c" () {
    sdl_app_quit(nil, {})
}

@export
web_window_size_changed :: proc "c" (w: c.int, h: c.int) {
}


sdl_app_init :: proc "c" (appstate: ^rawptr, argc: i32, argv: [^]cstring) -> SDL.AppResult {
    context = ctx
    _ = SDL.SetAppMetadata("Example", "1.0", "com.example")

    if (!SDL.Init(SDL.INIT_VIDEO)) {
        return .FAILURE
    }
    if (!SDL.CreateWindowAndRenderer("examples", 640, 480, {}, &window, &renderer)){
        return .FAILURE
    }

    engine = TTF.CreateRendererTextEngine(renderer)

    return .CONTINUE
}

sdl_app_event :: proc "c" (appstate: rawptr, event: ^SDL.Event) -> SDL.AppResult {
    context = ctx
    // fmt.println("event")
    if event.type == .QUIT {
        return .SUCCESS
    }
    return .CONTINUE
}

sdl_app_iterate :: proc "c" (appstate: rawptr) -> SDL.AppResult {
    context = ctx
    //fmt.println("hello")

    SDL.SetRenderDrawColor(renderer, 0, 0, 0, 255)
    //SDL.RenderClear(renderer)

    rect := SDL.FRect{w = f32(texture_size.x), h = f32(texture_size.y)}
    rect.w = 100
    rect.h = 100

    //SDL.SetRenderDrawBlendMode(renderer, .ADD)
    SDL.SetRenderDrawColor(renderer, 255, 0, 0, 255)
    SDL.RenderFillRect(renderer, &rect)
    SDL.SetRenderDrawColor(renderer, 255, 0, 255, 255)
    SDL.RenderRect(renderer, &rect)

    if texture != nil {
       rect.w = f32(texture.w)
       rect.h = f32(texture.h)
       SDL.RenderTexture(renderer, texture, nil, &rect)
    }

    SDL.RenderPresent(renderer)


    return .CONTINUE
}


sdl_app_quit :: proc "c" (appstate: rawptr, result: SDL.AppResult) {
    // fmt.println("quit")

}

main :: proc() {
ctx = context
}

//when ODIN_OS != .Freestanding {
/*
    main :: proc () {
        // fmt.println("main")
        ctx = context
        //args := os.args
        SDL.EnterAppMainCallbacks(0, nil, sdl_app_init, sdl_app_iterate, sdl_app_event, sdl_app_quit)
    }
*/
//}
