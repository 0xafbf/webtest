
package main


import SDL "vendor:sdl3"
//import IMG "vendor:sdl3/image"
import "core:fmt"
import "core:c"
// import "core:os"

import "base:runtime"

import "emscripten"

ctx: runtime.Context

window: ^SDL.Window
renderer: ^SDL.Renderer
texture: ^SDL.Texture
texture_size: [2]i32


// @(export) emscripten_cancel_main_loop :: proc "c" () {

// }
// @(export) abort :: proc "c" () {

// }
@export
main_start :: proc "c" () {
    sdl_app_init(nil, 0, nil)


    fetch_attr := emscripten.emscripten_fetch_attr_t {}
    emscripten.emscripten_fetch_attr_init(&fetch_attr)
    fetch_attr.onsuccess = fetch_success
    emscripten.emscripten_fetch(&fetch_attr, "/sample.bmp")
}

fetch_success :: proc "c" (^emscripten.emscripten_fetch_t) {
    context = ctx
    fmt.println("success")

}

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
    // fmt.println("init")
    _ = SDL.SetAppMetadata("Example", "1.0", "com.example")

    if (!SDL.Init(SDL.INIT_VIDEO)) {
        // fmt.println("fail init video")

        return .FAILURE
    }
    if (!SDL.CreateWindowAndRenderer("examples", 640, 480, {}, &window, &renderer)){
        // fmt.println("fail create window")
        return .FAILURE
    }
    surface := SDL.LoadBMP("sample.bmp")
    texture = SDL.CreateTextureFromSurface(renderer, surface)
    texture_size = {surface.w, surface.h}

    SDL.DestroySurface(surface)
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
    //SDL.RenderTexture(renderer, texture, nil, &rect)
    //SDL.SetRenderDrawBlendMode(renderer, .ADD)
    SDL.SetRenderDrawColor(renderer, 255, 0, 0, 255)
    SDL.RenderLine(renderer, 0, 0, 100, 100)
    SDL.RenderRect(renderer, &rect)
    SDL.RenderFillRect(renderer, &rect)
    SDL.RenderPresent(renderer)

    return .CONTINUE
}

sdl_app_quit :: proc "c" (appstate: rawptr, result: SDL.AppResult) {
    // fmt.println("quit")

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
