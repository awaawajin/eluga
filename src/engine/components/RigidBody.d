module engine.components.RigidBody;

import std;
import engine;
import utils;

Vec2 g0 = Vec2(0, 9.81);

// Need components: Transform
class RigidBody: Component {
  Vec2 v, a, F, gF;
  real m; // 質量
  real e; // 反発係数
  real mu; // 摩擦係数

  Vec2 g(Vec2 _g) {
    gF = m * _g;
    return _g;
  }

  this(real m, real e = 1, real mu = 1, Vec2 v0 = Vec2(0, 0)) {
    this.m = m;
    this.g = g0;
    this.e = e;
    this.mu = mu;
    this.v = v0;
  }

  void addForce(Vec2 F) {
    this.F = F;
  }

  // 反発(引数はx,y方向反転のbool値と壁の衝突かの判定)
  void repulsion(Pair!bool touchDir, bool isWall = false) {
    auto touchVec = Vec2(touchDir.a ? -1 : 0, touchDir.b ? -1 : 0);
    auto repVec = touchVec * this.v * m * e;
    addForce(repVec);
  }

  private bool objectsConflict(Vec2 pos1, GameObject obj2) {
    Vec2 pos2 = obj2.component!Transform.pos;
    Vec2 size1 = go.component!BoxCollider.worldScale;
    Vec2 size2 = obj2.component!BoxCollider.worldScale;
    Vec2 center1 = pos1 + size1/2;
    Vec2 center2 = pos2 + size2/2;
    
    bool hFlag = abs(center1.y - center2.y) < (size1.y + size2.y)/2.0;
    bool wFlag = abs(center1.x - center2.x) < (size1.x + size2.x)/2.0;

    return hFlag && wFlag;
  }

  private Tuple!(Vec2, "v", real, "d") conflict(){
    if(!go.has!BoxCollider) return typeof(return)(v,go.dur);
    auto tform = go.component!Transform;
    auto gos = go.ctx.root.everyone.filter!(e => e.has!BoxCollider && e.has!Transform).array;
    Vec2 afterPos, resV = v;
    real dur = go.dur;
    foreach(i, p; gos) {
      if(p == go) continue;
      afterPos = tform.pos + v*dur;
      foreach(j, q; gos) {
        if(q == go) continue;
        if(objectsConflict(afterPos,q)){
          real ok = 0, ng = dur, mid;
          while(abs(ok - ng) > 0.1){
            mid = (ok + ng) / 2.0;
            afterPos = tform.pos + resV * mid;
            if(objectsConflict(afterPos, q)) {
              ng = mid;
            }
            else ok = mid;
          }
          dur = ok;
          resV = v;
        }
        if(objectsConflict(tform.pos + Vec2(resV.x,0) * (dur + 0.1), q)) resV.x = 0;
        if(objectsConflict(tform.pos + Vec2(0,resV.y) * (dur + 0.1), q)) resV.y = 0;
      }
    }
    return typeof(return)(resV,dur);
  }

  override void loop() {
    auto tform = go.component!Transform;
    a = (F+gF) / m;
    F = Vec2(0, 0);
    v += a*go.dur/256;
    auto res = conflict();
    v = res.v;
    tform.pos += v*res.d;
  }
}
