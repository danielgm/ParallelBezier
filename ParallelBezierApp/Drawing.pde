
import java.util.Iterator;

class Drawing {
  ParallelBezierSet bezierSet;
  private boolean isEditMode;

  void setup() {
    bezierSet = new ParallelBezierSet();
    bezierSet.load("settings.json");

    fileNamer = new FileNamer("output/export", "png");

    isEditMode(true);
  }

  void load(String path) {
    JSONObject json = loadJSONObject(path);
    updateFromJSONObject(json);
  }

  void draw(PGraphics g) {
    g.background(255);
    g.stroke(0);
    g.strokeWeight(2);
    g.noFill();

    bezierSet.draw(g);
  }

  boolean isEditMode() {
    return isEditMode;
  }

  Drawing isEditMode(boolean v) {
    isEditMode = v;

    bezierSet.isEditMode(v);

    return this;
  }

  void mousePressed() {
    bezierSet.mousePressed();
  }

  void mouseDragged() {
    bezierSet.mouseDragged();
  }

  void mouseReleased() {
    bezierSet.mouseReleased();
  }

  private void updateFromJSONObject(JSONObject json) {
    bezierSet = new ParallelBezierSet();
    bezierSet.updateFromJSONObject(json);
  }

  private JSONObject toJSONObject() {
    JSONObject json = bezierSet.toJSONObject();
    return json;
  }
}
