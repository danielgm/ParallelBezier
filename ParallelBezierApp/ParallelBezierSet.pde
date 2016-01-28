
import java.util.Iterator;

class ParallelBezierSet {
  private ArrayList<EditableLineSegment> controls;
  private ArrayList<EditableBezierCurve> curves;
  private int numBeziers;
  private boolean isEditMode;

  ParallelBezierSet() {
    controls = new ArrayList<EditableLineSegment>();
    curves = new ArrayList<EditableBezierCurve>();

    // FIXME: User configurable.
    numBeziers = 20;

    isEditMode(true);
  }

  void load(String path) {
    JSONObject json = loadJSONObject(path);
    updateFromJSONObject(json);
  }

  void draw(PGraphics g) {
    drawInterpolatedCurves(g);

    if (isEditMode) {
      g.pushStyle();
      g.stroke(0);
      g.strokeWeight(2);
      drawCurves(g);
      drawControls(g);
      g.popStyle();
    }
  }

  void drawInterpolatedCurves(PGraphics g) {
    ArrayList<EditableLineSegment> controls0 = curves.get(0).controls();
    ArrayList<EditableLineSegment> controls1 = curves.get(1).controls();

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

  void drawCurves(PGraphics g) {
    Iterator<EditableBezierCurve> iter = curves.iterator();
    while (iter.hasNext()) {
      EditableBezierCurve curve = iter.next();
      curve.draw(g);
    }
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

  private void updateFromJSONObject(JSONObject json) {
    controls = new ArrayList<EditableLineSegment>();
    curves = new ArrayList<EditableBezierCurve>();

    JSONArray jsonCurves = json.getJSONArray("curves");
    updateCurvesFromJSONArray(jsonCurves);
  }

  private void updateCurvesFromJSONArray(JSONArray jsonCurves) {
    for (int i = 0; i < jsonCurves.size(); i++) {
      JSONObject jsonCurve = jsonCurves.getJSONObject(i);

      EditableBezierCurve curve = new EditableBezierCurve();
      curve.updateFromJSONObject(jsonCurve);
      curves.add(curve);

      addControls(curve);
    }
  }

  private void addControls(EditableBezierCurve curve) {
    ArrayList<EditableLineSegment> curveControls = curve.controls();
    Iterator<EditableLineSegment> iter = curveControls.iterator();
    while (iter.hasNext()) {
      EditableLineSegment control = iter.next();
      control.isEditMode = isEditMode;
      controls.add(control);
    }
  }

  private JSONObject toJSONObject() {
    JSONObject json = new JSONObject();
    json.setJSONArray("curves", curvesToJSONObject());
    return json;
  }

  private JSONArray curvesToJSONObject() {
    JSONArray jsonCurves = new JSONArray();
    for (int i = 0; i < curves.size(); i++) {
      jsonCurves.setJSONObject(i, curves.get(i).toJSONObject());
    }
    return jsonCurves;
  }
}

