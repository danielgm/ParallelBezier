
import java.util.Iterator;

class ParallelBeziers {
  private ArrayList<EditableLineSegment> controls;
  private ArrayList<EditableBezierCurve> curves;
  private boolean isEditMode;

  ParallelBeziers() {
    controls = new ArrayList<EditableLineSegment>();
    curves = new ArrayList<EditableBezierCurve>();

    isEditMode(true);
  }

  void load(String path) {
    JSONObject json = loadJSONObject(path);
    updateFromJSONObject(json);
  }

  void draw(PGraphics g) {
    g.beginDraw();
    g.pushStyle();

    drawCurves(g);
    drawControls(g);

    g.popStyle();
    g.endDraw();
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

  ParallelBeziers isEditMode(boolean v) {
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
    ArrayList<EditableLineSegment> curveControls = curve.getControls();
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

