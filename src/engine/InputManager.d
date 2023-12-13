module engine.InputManager;

import std.bitmanip;

class InputManager {
  package BitArray state,once;
  package char oldKey = 0;

  this() {
    enum stateSize = ubyte.max;
    state = BitArray(new ubyte[stateSize / 8], stateSize);
    once = BitArray(new ubyte[stateSize / 8], stateSize);
  }

  // keyが押されているかを取得
  bool key(char key) const => state[key];

  // keyが押されたかを1回だけ返す
  bool keyOnce(int key) const {
    return once[key];
  }
}
