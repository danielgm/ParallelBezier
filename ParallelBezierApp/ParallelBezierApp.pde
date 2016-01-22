
import java.util.Iterator;

ArrayList<EditableLineSegment> segments;
ArrayList<EditableBezierSegment> beziers;
ArrayList<EditableBezierCurve> curves;

FileNamer fileNamer;

color strokeColor, backgroundColor0, backgroundColor1;

void setup() {
  size(640, 640, P2D);

  segments = new ArrayList<EditableLineSegment>();
  beziers = new ArrayList<EditableBezierSegment>();
  curves = new ArrayList<EditableBezierCurve>();
  loadSegments("settings.json");
  //createSegments();
  //createCurves();

  strokeColor = 0xff030303;
  backgroundColor0 = 0xff69d3ce;
  backgroundColor1 = 0xff887abf;

  fileNamer = new FileNamer("output/export", "png");

  isEditMode(true);
}

void createSegments() {
  createSegment(
      0.2 * width, 0.5 * height, 0.3 * width, 0.5 * height,
      0.7 * width, 0.8 * height, 0.8 * width, 0.8 * height);
  createSegment(
      0.2 * width, 0.6 * height, 0.3 * width, 0.6 * height,
      0.7 * width, 0.9 * height, 0.8 * width, 0.9 * height);
}

void createSegment(
    float x0, float y0, float x1, float y1,
    float x2, float y2, float x3, float y3) {
  EditableLineSegment start = new EditableLineSegment(x0, y0, x1, y1);
  EditableLineSegment end = new EditableLineSegment(x2, y2, x3, y3);

  segments.add(start);
  segments.add(end);

  beziers.add(new EditableBezierSegment(start, end));
}

void loadSegments(String path) {
  JSONObject json = loadJSONObject(path);
  updateFromJSONObject(json);
}

void createCurves() {
  EditableBezierCurve curve;

  curve = new EditableBezierCurve();
  curve.addControl(new EditableLineSegment(100, 200, 120, 150));
  curve.addControl(new EditableLineSegment(300, 130, 350, 120));
  curve.addControl(new EditableLineSegment(450, 300, 500, 320));
  curves.add(curve);

  curve = new EditableBezierCurve();
  curve.addControl(new EditableLineSegment(100, 400, 120, 350));
  curve.addControl(new EditableLineSegment(300, 330, 350, 320));
  curve.addControl(new EditableLineSegment(450, 500, 500, 520));
  curves.add(curve);
}

void draw() {
  drawInterference(g);
}

void drawInterference(PGraphics g) {
  g.beginDraw();
  g.pushStyle();

  g.background(255);

  g.noFill();
  g.stroke(strokeColor);
  g.strokeWeight(4);

  drawSegments(g);
  drawBeziers(g);
  drawCurves(g);

  g.popStyle();
  g.endDraw();
}

void drawSegments(PGraphics g) {
  Iterator<EditableLineSegment> iter = segments.iterator();
  while (iter.hasNext()) {
    EditableLineSegment segment = iter.next();
    segment.draw(g);
  }
}

void drawBeziers(PGraphics g) {
  Iterator<EditableBezierSegment> iter = beziers.iterator();
  while (iter.hasNext()) {
    EditableBezierSegment bezier = iter.next();
    bezier.draw(g);
  }
}

void drawCurves(PGraphics g) {
  Iterator<EditableBezierCurve> iter = curves.iterator();
  while (iter.hasNext()) {
    EditableBezierCurve curve = iter.next();
    curve.draw(g);
  }
}

void isEditMode(boolean v) {
  Iterator<EditableLineSegment> iter = segments.iterator();
  while (iter.hasNext()) {
    EditableLineSegment segment = iter.next();
    segment.isEditMode(v);
  }
}

void keyReleased() {
  switch (key) {
    case 'r':
      save(fileNamer.next());
      break;
    case 's':
      saveJSONObject(toJSONObject(), "settings.json");
      break;
  }
}

void mousePressed() {
  Iterator<EditableLineSegment> iter = segments.iterator();
  while (iter.hasNext()) {
    EditableLineSegment segment = iter.next();
    segment.mousePressed();
  }
}

void mouseDragged() {
  Iterator<EditableLineSegment> iter = segments.iterator();
  while (iter.hasNext()) {
    EditableLineSegment segment = iter.next();
    segment.mouseDragged();
  }
}

void mouseReleased() {
  Iterator<EditableLineSegment> iter = segments.iterator();
  while (iter.hasNext()) {
    EditableLineSegment segment = iter.next();
    segment.mouseReleased();
  }
}

private void updateFromJSONObject(JSONObject json) {
  segments = new ArrayList<EditableLineSegment>();
  beziers = new ArrayList<EditableBezierSegment>();
  curves = new ArrayList<EditableBezierCurve>();

  JSONArray jsonBeziers = json.getJSONArray("beziers");
  updateBeziersFromJSONArray(jsonBeziers);

  JSONArray jsonCurves = json.getJSONArray("curves");
  updateCurvesFromJSONArray(jsonCurves);
}

private void updateBeziersFromJSONArray(JSONArray jsonBeziers) {
  for (int i = 0; i < jsonBeziers.size(); i++) {
    JSONObject jsonBezier = jsonBeziers.getJSONObject(i);

    EditableBezierSegment bezier = new EditableBezierSegment();
    bezier.updateFromJSONObject(jsonBezier);
    beziers.add(bezier);

    segments.add(new EditableLineSegment(bezier.getP0(), bezier.getC0()));
    segments.add(new EditableLineSegment(bezier.getC1(), bezier.getP1()));
  }
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
    segments.add(iter.next());
  }
}

private JSONObject toJSONObject() {
  JSONObject json = new JSONObject();
  json.setJSONArray("beziers", beziersToJSONObject());
  json.setJSONArray("curves", curvesToJSONObject());
  return json;
}

private JSONArray beziersToJSONObject() {
  JSONArray jsonBeziers = new JSONArray();
  for (int i = 0; i < beziers.size(); i++) {
    jsonBeziers.setJSONObject(i, beziers.get(i).toJSONObject());
  }
  return jsonBeziers;
}

private JSONArray curvesToJSONObject() {
  JSONArray jsonCurves = new JSONArray();
  for (int i = 0; i < curves.size(); i++) {
    jsonCurves.setJSONObject(i, curves.get(i).toJSONObject());
  }
  return jsonCurves;
}

