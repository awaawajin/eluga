module engine.GameObject;

import std;
import sdl;
import engine;

class GameObject: Loggable {
  private GameObject[] children;
  private Component[] components;
  private GameObject _parent;
  package bool alreadySetup = false;

  GameObject parent() {
    if(!_parent.alreadySetup) warn("parent (", _parent, ") is not set up yet!");
    return _parent;
  }

  // context

  package Context* ctx;

  real dur() const => ctx.elapsed / 10.;
  auto im() const => ctx.im;
  auto everyone() => ctx.root.descendant;

  // todo: いい感じのRangeにするかもしれないし，しないかもしれない
  private GameObject[] descendant() => children ~ children.map!(e => e.descendant).join;

  // core functions

  void setup() {}
  void loop() {}
  void collide(GameObject go) {}

  debug {
    void debugSetupPre() {}
    void debugSetup() {}
    void debugLoopPre() {}
    void debugLoop() {}
  }

  package void realSetup(Context* ctx) {
    this.ctx = ctx;
    foreach(c; components) {
      debug c.debugSetupPre;
      try c.setup;
      catch(Exception e) err("Component exception in setup\n", e);
      debug c.debugSetup;
    }
    foreach(e; children) e.realSetup(ctx);
    alreadySetup = true;
    debug debugSetupPre;
    try setup;
    catch(Exception e) err("GameObject exception in setup\n", e);
    debug debugSetup;
  }

  package void realLoop() {
    foreach(c; components) {
      debug c.debugLoopPre;
      try c.realLoop;
      catch(Exception e) err("Component exception in loop\n", e);
      debug c.debugLoop;
    }
    debug debugLoopPre;
    try loop;
    catch(Exception e) err("GameObject exception in loop\n", e);
    debug debugLoop;
    foreach(e; children) e.realLoop;
  }

  // utils

  protected void line(Vec2 a, Vec2 b) {
    color(255, 0, 0);
    SDL_RenderDrawLine(ctx.r, cast(int)a.x, cast(int)a.y, cast(int)b.x, cast(int)b.y);
  }

  protected void color(ubyte r, ubyte g, ubyte b, ubyte a = 255) {
    SDL_SetRenderDrawColor(ctx.r, r, g, b, a);
  }

  // components

  C component(C: Component, string file = __FILE__, size_t line = __LINE__)() {
    auto res = findComponent!C.e;
    if(res) return res;
    throw new Nullpo("Component " ~ C.stringof ~ " was not found in " ~ this.toString, file, line);
  }

  bool has(C: Component)() const => findComponent!C.e !is null;

  private Tuple!(ulong, "i", C, "e") findComponent(C: Component)() const {
    foreach(i, e; components) {
      auto res = cast(C)e;
      if(res) return typeof(return)(i, res);
    }
    enum notFound = typeof(return)(0, null);
    return notFound;
  }

  // GO-tree

  auto register(A...)(A a) {
    static foreach(e; a) register(e);
    static if(!A.length) return null;
    else return a[0];
  }

  T register(T)(T[] t) {
    foreach(e; t) register(e);
    return t.length ? t.front : null;
  }

  GO register(GO: GameObject)(GO e) {
    auto go = cast(GameObject)e;
    go._parent = this;
    children ~= go;
    if(alreadySetup) go.realSetup(ctx);
    return e;
  }

  C register(C: Component)(C c) {
    c.go = this;
    if(has!C) {
      warn("registering ", C.stringof, " to ", this, " is duplicate; dropping this");
      warn("hint: you can update component with upsert(component)");
      return component!C;
    }
    components ~= c;
    if(alreadySetup) c.setup;
    return c;
  }

  C upsert(C: Component)(C c) {
    c.go = this;
    auto old = findComponent!C;
    if(old.e) components[old.i] = c;
    else components ~= c;
    if(alreadySetup) c.setup;
    return c;
  }

  void destroy() {
    foreach(i, e; parent.children) if(e == this) {
      parent.children = parent.children.remove(i);
      return;
    }
  }
}
