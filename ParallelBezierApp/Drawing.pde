
import java.util.Iterator;

class Drawing {
  ArrayList<ParallelBezierSet> bezierSets;
  private boolean isEditMode;
  private int editingIndex;

  final static color editingColor = 0xffff0000;
  final static color normalColor = 0xff333333;

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
      g.stroke(getStrokeColor(bezierSet));
      bezierSet.draw(g);
    }
  }

  private color getStrokeColor(ParallelBezierSet bezierSet) {
    return bezierSet.isEditMode() ? editingColor : normalColor;
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
