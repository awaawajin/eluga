module game.entities.Missile;

import engine;

class Missile: GameObject {
  enum Type {
    Normal,
  }

  Type type;

  this(Type type, Vec2 dir, Vec2 pos) {
    this.type = type;

    register(new Transform()).pos = pos;
    register(new Focus(1));
    auto rb = register(new RigidBody(1));
    rb.a = Vec2(0, 0);
    auto missile = new ImageAsset("hero0.png");
    register(new SpriteRenderer(missile));

    final switch(type) {
      case Type.Normal:
        if(dir.x >= 0) rb.addForce(Vec2(3, 0));
        else rb.addForce(Vec2(-3, 0));
        rb.g = Vec2(0, 0);
        break;
    }

    auto clip = new AudioAsset("se_rifle01.mp3");
    // auto audio = register(new AudioSource(clip));
    // audio.volume(20);
    // audio.play();
  }

  override void loop() {
    auto tform = component!Transform;
    tform.rot++;
    if(tform.pos.x > 1000 || tform.pos.y > 1000) destroy;
    final switch(type) {
      case Type.Normal: break;
    }
  }
}
