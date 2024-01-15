module engine.components.Transform;

import engine;

class Transform: Component {
  // 左端基準ズームか中心基準ズームか
  enum Zoom{
    Corner,
    Center,
  }

  // 相対座標か絶対座標か初期位置のみ相対座標か
  enum Org{
    World,
    Local,
    Spawn,
  }

  // 一般座標系
  private Zoom zoom;
  private Org org;
  Vec2 pos = Vec2(0, 0);
  Vec2 worldPos = Vec2(0, 0);
  Vec2 basePos = Vec2(0, 0); // 基準点(オブジェクトでのゼロ点)
  real rot = 0;
  Vec2 scale = Vec2(1, 1);
  GameObject cgo;
  Camera cc;

  private bool looped;

  // Obj範囲内にWinのどっちかの端があるかという考え方
  bool isin(Vec2 sz,bool d = false) {
    if(d){
      if(cc is null) return false;
    }
    return cc is null ? false : !(((worldPos.x > cc.pos.x + cc.size.x) || (worldPos.x + sz.x < cc.pos.x)) || ((worldPos.y + sz.y < cc.pos.y) || (worldPos.y > cc.pos.y + cc.size.y)));
  } 

  bool isZoomCenter() => (zoom == Zoom.Center);

  this(Org worldType = Org.Local, Zoom zoomType = Zoom.Corner){
    zoom = zoomType;
    org = worldType;
  }

  auto translate(Vec2 d) => pos += d;

  override void loop() {
    campos;
    worldPos = pos + basePos;
    
    auto parent = go.parent;
    if(!parent.has!Transform) return;

    // 親位置
    auto pPos = parent.component!Transform;
    if(org == Org.Local || (org == Org.Spawn && !looped)) basePos = pPos.worldPos;
    cc = cgo is null ? null : cgo.component!Camera; // Cameraを参照します
    looped = true;
  }

  // カメラ座標系
  Vec2 campos() {
    cgo = go;
    while(!cgo.has!Camera) cgo = cgo.parent; // Camera持ちまで登る
    auto retpos = this.worldPos  - cgo.component!Camera.pos ;
    return retpos;
  }

  Vec2 camscale() {
    // やりたくありません
    return scale;
  }
}
