
import java.util.Iterator;

class ParallelBezierSet {
  private ArrayList<EditableLineSegment> controls;
  private EditableBezierCurve bezier0;
  private EditableBezierCurve bezier1;
  private int numBeziers;
  private boolean isEditMode;
  private color strokeColor;

  final static color editingColor = 0xffff0000;

  ParallelBezierSet() {
    controls = new ArrayList<EditableLineSegment>();
    bezier0 = new EditableBezierCurve();
    bezier1 = new EditableBezierCurve();

    // FIXME: User configurable.
    numBeziers = 120;
    isEditMode = false;
    strokeColor = color(0);
  }

  void load(String path) {
    JSONObject json = loadJSONObject(path);
    updateFromJSONObject(json);
  }

  void draw(PGraphics g) {
    g.pushStyle();
    if (isEditMode()) {
      g.stroke(editingColor);
    }
    else {
      g.stroke(strokeColor);
    }

    drawInterpolatedBeziers(g);

    if (isEditMode) {
      drawBeziers(g);
      drawControls(g);
    }

    g.popStyle();
  }

  void drawInterpolatedBeziers(PGraphics g) {
    ArrayList<EditableLineSegment> controls0 = bezier0.controls();
    ArrayList<EditableLineSegment> controls1 = bezier1.controls();

    int size = min(controls0.size(), controls1.size());
    for (int i = 0; i < size - 1; i++) {
      LineSegment currControl0 = controls0.get(i);
      LineSegment nextControl0 = controls0.get(i + 1);
      LineSegment currControl1 = controls1.get(i);
      LineSegment nextControl1 = controls1.get(i + 1);

      for (int n = 0; n < numBeziers; n++) {
        float t = (float)n / numBeziers;
        LineSegment currLerped = currControl0.lerp(currControl1, t);
        LineSegment nextLerped = nextControl0.lerp(nextControl1, t);

        if (i == 0) {
          g.bezier(
            currLerped.p0.x, currLerped.p0.y, currLerped.p1.x, currLerped.p1.y,
            nextLerped.p0.x, nextLerped.p0.y, nextLerped.p1.x, nextLerped.p1.y);
        }
        else {
          g.bezier(
            currLerped.p1.x, currLerped.p1.y, 2 * currLerped.p1.x - currLerped.p0.x, 2 * currLerped.p1.y - currLerped.p0.y,
            nextLerped.p0.x, nextLerped.p0.y, nextLerped.p1.x, nextLerped.p1.y);
        }
      }
    }
  }

  void drawBeziers(PGraphics g) {
    bezier0.draw(g);
    bezier1.draw(g);
  }

  void drawControls(PGraphics g) {
    Iterator<EditableLineSegment> iter = controls.iterator();
    while (iter.hasNext()) {
      EditableLineSegment segment = iter.next();
      segment.draw(g);
    }
  }

  boolean isEditMode() {
    return isEditMode;
  }

  ParallelBezierSet isEditMode(boolean v) {
    isEditMode = v;

    Iterator<EditableLineSegment> iter = controls.iterator();
    while (iter.hasNext()) {
      EditableLineSegment segment = iter.next();
      segment.isEditMode(v);
    }

    return this;
  }

  ArrayList<EditableLineSegment> controls() {
    return new ArrayList<EditableLineSegment>(controls);
  }

  void nudge(float x, float y) {
    Iterator<EditableLineSegment> iter = controls.iterator();
    while (iter.hasNext()) {
      EditableLineSegment segment = iter.next();
      segment.nudge(x, y);
    }

    bezier0.nudge(x, y);
    bezier1.nudge(x, y);
  }
  
  ParallelBezierSet clone() {
    ParallelBezierSet cloned = new ParallelBezierSet();
    cloned.bezier0 = bezier0.clone();
    cloned.bezier1 = bezier1.clone();
    cloned.addControls(cloned.bezier0);
    cloned.addControls(cloned.bezier1);
    cloned.numBeziers = numBeziers;
    cloned.isEditMode = isEditMode;
    cloned.strokeColor = strokeColor;
    
    return cloned;
  }

  void mousePressed() {
    Iterator<EditableLineSegment> iter = controls.iterator();
    while (iter.hasNext()) {
      EditableLineSegment segment = iter.next();
      segment.mousePressed();
    }
  }

  void mouseDragged() {
    Iterator<EditableLineSegment> iter = controls.iterator();
    while (iter.hasNext()) {
      EditableLineSegment segment = iter.next();
      segment.mouseDragged();
    }
  }

  void mouseReleased() {
    Iterator<EditableLineSegment> iter = controls.iterator();
    while (iter.hasNext()) {
      EditableLineSegment segment = iter.next();
      segment.mouseReleased();
    }
  }

  void positionChanged() {
    Iterator<EditableLineSegment> iter = controls.iterator();
    while (iter.hasNext()) {
      EditableLineSegment segment = iter.next();
      segment.positionChanged();
    }
  }

  private void updateFromJSONObject(JSONObject json) {
    controls = new ArrayList<EditableLineSegment>();

    strokeColor = color(unhex("FF" + json.getString("stroke").substring(1)));

    bezier0 = new EditableBezierCurve();
    bezier0.updateFromJSONObject(json.getJSONObject("bezier0"));
    addControls(bezier0);

    bezier1 = new EditableBezierCurve();
    bezier1.updateFromJSONObject(json.getJSONObject("bezier1"));
    addControls(bezier1);
  }

  private void addControls(EditableBezierCurve bezier) {
    ArrayList<EditableLineSegment> bezierControls = bezier.controls();
    Iterator<EditableLineSegment> iter = bezierControls.iterator();
    while (iter.hasNext()) {
      EditableLineSegment control = iter.next();
      control.isEditMode = isEditMode;
      controls.add(control);
    }
  }

  private JSONObject toJSONObject() {
    JSONObject json = new JSONObject();
    json.setString("stroke", "#" + hex(strokeColor, 6));
    json.setJSONObject("bezier0", bezier0.toJSONObject());
    json.setJSONObject("bezier1", bezier1.toJSONObject());
    return json;
  }
}