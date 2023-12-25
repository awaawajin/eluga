module engine.Context;

import core.time;
import std.string;
import sdl;
import engine;

enum initFps = 60.;

struct Context {
  bool running = true;

  package {
    // [ms]
    ulong dur = cast(ulong)(1000 / initFps);
    ulong updated;
    ulong elapsed;
  }
  real fps() => 1000. / dur;
  real fps(real v) {
    dur = cast(ulong)(1000 / v);
    return fps;
  }

  GameObject root;
  InputManager im;

  SDL_Window* w;
  SDL_Renderer* r;

  SDL_Window* createWin(string title = "game", int w = 640, int h = 480) =>
    this.w = SDL_CreateWindow(title.toStringz,
                              SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
                              w, h,
                              SDL_WINDOW_OPENGL);

  SDL_Renderer* createRdr() =>
    this.r = SDL_CreateRenderer(this.w,
                                -1,
                                SDL_RENDERER_ACCELERATED);
}
