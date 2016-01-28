
import java.util.Iterator;

class Drawing {
  ArrayList<ParallelBezierSet> bezierSets;
  private boolean isEditMode;

  void setup() {
    bezierSets = new ArrayList<ParallelBezierSet>();

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

    drawBezierSets();
  }

  private void drawBezierSets() {
    Iterator<ParallelBezierSet> iter = bezierSets.iterator();
    while (iter.hasNext()) {
      ParallelBezierSet bezierSet = iter.next();
      bezierSet.draw(g);
    }
  }

  boolean isEditMode() {
    return isEditMode;
  }

  Drawing isEditMode(boolean v) {
    isEditMode = v;

    Iterator<ParallelBezierSet> iter = bezierSets.iterator();
    while (iter.hasNext()) {
      ParallelBezierSet bezierSet = iter.next();
      bezierSet.isEditMode(v);
    }

    return this;
  }

  void mousePressed() {
    Iterator<ParallelBezierSet> iter = bezierSets.iterator();
    while (iter.hasNext()) {
      ParallelBezierSet bezierSet = iter.next();
      bezierSet.mousePressed();
    }
  }

  void mouseDragged() {
    Iterator<ParallelBezierSet> iter = bezierSets.iterator();
    while (iter.hasNext()) {
      ParallelBezierSet bezierSet = iter.next();
      bezierSet.mouseDragged();
    }
  }

  void mouseReleased() {
    Iterator<ParallelBezierSet> iter = bezierSets.iterator();
    while (iter.hasNext()) {
      ParallelBezierSet bezierSet = iter.next();
      bezierSet.mouseReleased();
    }
  }

  private void updateFromJSONObject(JSONObject json) {
    JSONArray jsonBezierSets = json.getJSONArray("bezierSets");
    bezierSets = new ArrayList<ParallelBezierSet>();
    for (int i = 0; i < jsonBezierSets.size(); i++) {
      ParallelBezierSet bezierSet = new ParallelBezierSet();
      bezierSet.updateFromJSONObject(jsonBezierSets.getJSONObject(i));

      bezierSets.add(bezierSet);
    }
  }

  private JSONObject toJSONObject() {
    JSONObject json = new JSONObject();
    json.setJSONArray("bezierSets", bezierSetsToJSONArray());
    return json;
  }

  private JSONArray bezierSetsToJSONArray() {
    JSONArray jsonBezierSets = new JSONArray();
    for (int i = 0; i < bezierSets.size(); i++) {
      jsonBezierSets.setJSONObject(i, bezierSets.get(i).toJSONObject());
    }
    return jsonBezierSets;
  }
}
