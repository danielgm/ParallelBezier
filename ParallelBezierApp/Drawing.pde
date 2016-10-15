
import java.util.Iterator;

class Drawing {
  ArrayList<ParallelBezierSet> bezierSets;
  private boolean isEditMode;
  private int editingIndex;
  private int width;
  private int height;

  Drawing(int w, int h) {
    width = w;
    height = h;
  }

  void setup() {
    bezierSets = new ArrayList<ParallelBezierSet>();

    editingIndex(0);
    isEditMode(true);
  }

  void load(String path) {
    JSONObject json = loadJSONObject(path);
    updateFromJSONObject(json);
  }

  void draw(PGraphics g) {
    drawBezierSets(g);
  }

  private void drawBezierSets(PGraphics g) {
    for (int i = 0; i < bezierSets.size(); i++) {
      ParallelBezierSet bezierSet = bezierSets.get(i);
      bezierSet.draw(g);
    }
  }
  
  void duplicate() {
    if (isEditMode) {
      ParallelBezierSet original = bezierSets.get(editingIndex);
      bezierSets.add(original.clone());
    }
  }

  boolean isEditMode() {
    return isEditMode;
  }

  Drawing isEditMode(boolean v) {
    isEditMode = v;
    editingIndexChanged();
    return this;
  }

  int editingIndex() {
    return editingIndex;
  }

  Drawing editingIndex(int v) {
    editingIndex = v;
    editingIndexChanged();
    return this;
  }

  Drawing prevEditingIndex() {
    editingIndex--;
    if (editingIndex < 0) {
      editingIndex = bezierSets.size() - 1;
    }
    editingIndexChanged();
    return this;
  }

  Drawing nextEditingIndex() {
    editingIndex++;
    if (editingIndex >= bezierSets.size()) {
      editingIndex = 0;
    }
    editingIndexChanged();
    return this;
  }

  private void editingIndexChanged() {
    for (int i = 0; i < bezierSets.size(); i++) {
      bezierSets.get(i).isEditMode(isEditMode && i == editingIndex);
    }
  }

  void nudge(float x, float y) {
    if (isEditMode) {
      ParallelBezierSet bezierSet = bezierSets.get(editingIndex);
      bezierSet.nudge(x, y);
      bezierSet.positionChanged();
    }
  }

  void randomize() {
    Iterator<ParallelBezierSet> iter = bezierSets.iterator();
    while (iter.hasNext()) {
      ParallelBezierSet bezierSet = iter.next();
      randomize(bezierSet);
    }
  }

  private void randomize(ParallelBezierSet bezierSet) {
    ArrayList<EditableLineSegment> controls = bezierSet.controls();
    Iterator<EditableLineSegment> iter = controls.iterator();
    while (iter.hasNext()) {
      EditableLineSegment control = iter.next();
      control.getP0().set(random(width), random(height));
      control.getP1().set(random(width), random(height));
      control.positionChanged();
    }
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