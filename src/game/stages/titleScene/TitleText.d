module game.stages.titleScene.TitleText;

import engine;
import game;

class TitleText: GameObject {
  Transform transform;
  TextAsset font;
  Text text;
  
  override void setup(){
    transform = register(new Transform);
    font = new TextAsset("assets/PixelMplus-20130602/PixelMplus12-Regular.ttf",40);
    text = register(new Text(font));
    text.setText("Test Title");
    auto window = register(new Window);
    component!Transform.pos = window.size()/2;
  }
}
