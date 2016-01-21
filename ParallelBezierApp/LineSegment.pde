
class LineSegment implements IVectorFunction {
  private PVector p0, p1;

  LineSegment() {
    set();
  }

  LineSegment(
      float startX, float startY,
      float endX, float endY) {
    set(startX, startY, endX, endY);
  }

  LineSegment(
      PVector start, PVector end) {
    set(start, end);
  }

  PVector getP0() {
    return p0.copy();
  }

  PVector getP1() {
    return p1.copy();
  }

  void set() {
    p0 = new PVector();
    p1 = new PVector();
  }

  void set(
      float startX, float startY,
      float endX, float endY) {
    p0 = new PVector(startX, startY);
    p1 = new PVector(endX, endY);
  }

  void set(
      PVector start, PVector end) {
    p0 = start.copy();
    p1 = end.copy();
  }

  void draw(PGraphics g) {
    g.line(p0.x, p0.y, p1.x, p1.y);
  }

  PVector getPoint(float t) {
    return PVector.add(p0, PVector.mult(PVector.sub(p1, p0), t));
  }

  LineSegment copy() {
    return new LineSegment(p0, p1);
  }

  JSONObject toJSONObject() {
    JSONObject json = new JSONObject();
    json.setJSONObject("p0", toJSONObject(p0));
    json.setJSONObject("p1", toJSONObject(p1));
    return json;
  }

  private JSONObject toJSONObject(PVector p) {
    JSONObject json = new JSONObject();
    json.setFloat("x", p.x);
    json.setFloat("y", p.y);
    return json;
  }

  void updateFromJSONObject(JSONObject json) {
    p0.x = json.getJSONObject("p0").getFloat("x");
    p0.y = json.getJSONObject("p0").getFloat("y");
    p1.x = json.getJSONObject("p1").getFloat("x");
    p1.y = json.getJSONObject("p1").getFloat("y");
  }
}
