module game.Game;

import engine;
import game;

alias Router = _Router!int;
alias RouteObject = _RouteObject!int;

enum Routes {
  Home, Title, Editor, GameOver, Abstract,
}

class Game: GameObject {
  Router router;

  override void setup() {
    router = register(new Router(Routes.Abstract, [
      Routes.Title: new TitleScene(),
      Routes.Home: new HomeScene(),
      Routes.Editor: new EditorScene(),
      Routes.GameOver: new GameOverScene(),
      Routes.Abstract: new AbstractScene(),
    ]));
    //register(new HomeScene);
    //register(new GameOverScene);

    // test msg
    // dbg("Hello, This is DBG");
    // log("Hello, This is LOG");
    // warn("Hello, This is WARN");
    // err("Hello, This is ERR");
    // dbg("Super Long Message: We workers have been exploited daily by the bourgeoisie, which is why we are now being hunted by a sense of mission that we must make a revolution");
    // log("Super Long Message: We workers have been exploited daily by the bourgeoisie, which is why we are now being hunted by a sense of mission that we must make a revolution");
    // warn("Super Long Message: We workers have been exploited daily by the bourgeoisie, which is why we are now being hunted by a sense of mission that we must make a revolution");
    // err("Super Long Message: We workers have been exploited daily by the bourgeoisie, which is why we are now being hunted by a sense of mission that we must make a revolution");
  }
}
