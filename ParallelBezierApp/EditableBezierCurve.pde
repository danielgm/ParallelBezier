
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;

class EditableBezierCurve {
  private BezierCurve curve;
  private ArrayList<EditableLineSegment> exposedControls;

  EditableBezierCurve() {
  }

  void draw(PGraphics g) {
    updateControls();
    curve.draw(g);
  }

  void draw(PGraphics g, float t0, float t1) {
    updateControls();
    curve.draw(g, t0, t1);
  }

  private void updateControls() {
    ArrayList<LineSegment> controls = new ArrayList<LineSegment>();
    Iterator<EditableLineSegment> iter = exposedControls.iterator();
    while (iter.hasNext()) {
      EditableLineSegment segment = iter.next();
      controls.add(segment);
    }
    curve.setControls(controls);
  }

  void addControl(EditableLineSegment control) {
    exposedControls.add(control);
    curve.addControl(control);
  }

  ArrayList<EditableLineSegment> getControls() {
    return new ArrayList<EditableLineSegment>(exposedControls);
  }

  void setControls(ArrayList<EditableLineSegment> newControls) {
      exposedControls = new ArrayList<EditableLineSegment>(newControls);
  }

  JSONObject toJSONObject() {
    return curve.toJSONObject();
  }

  void updateFromJSONObject(JSONObject json) {
    exposedControls = new ArrayList<EditableLineSegment>();
    JSONArray jsonControls = json.getJSONArray("controls");
    for (int i = 0; i < jsonControls.size(); i++) {
      EditableLineSegment segment = new EditableLineSegment();
      segment.updateFromJSONObject(jsonControls.getJSONObject(i));
      exposedControls.add(segment);
    }

    curve = new BezierCurve();
    curve.updateFromJSONObject(json);
  }
}

