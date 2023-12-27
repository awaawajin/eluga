module game.stages.home.HomeScene;

import std;
import game;
import engine;

class HomeScene: GameObject {
  Hero hero;
  ImageAsset bg;
  AudioAsset BGM;
  AudioSource audio;
  Transform tform;

  override void setup() {
    // vv hero vv
    hero = register(new Hero);

    // vv worldTrf vv
    tform = register(new Transform(Transform.Org.World));
    tform.scale.x = 1.5;

    // vv background vv
    bg = new ImageAsset("_.jpeg");
    auto sprite = register(new SpriteRenderer(bg));
    debug sprite.debugFrame = false;

    // vv userInterface vv
    register(new UI);

    // vv bgm vv
    BGM = new AudioAsset("maou_bgm_8bit29.ogg");
    audio = register(new AudioSource(BGM));
    audio.play(-1);
    audio.volume(15);
  }
}
