
class EditableBezierSegment extends BezierSegment {
  private PVector exposedP0;
  private PVector exposedC0;
  private PVector exposedC1;
  private PVector exposedP1;

  EditableBezierSegment() {
    super();
    exposedP0 = new PVector();
    exposedC0 = new PVector();
    exposedC1 = new PVector();
    exposedP1 = new PVector();
  }

  EditableBezierSegment(
      float startX, float startY,
      float startControlX, float startControlY,
      float endControlX, float endControlY,
      float endX, float endY) {
    super(
      startX, startY, startControlX, startControlY,
      endControlX, endControlY, endX, endY);
  }

  EditableBezierSegment(PVector start, PVector startControl, PVector endControl, PVector end) {
    super(start, startControl, endControl, end);
    exposedP0 = start;
    exposedC0 = startControl;
    exposedC1 = endControl;
    exposedP1 = end;
  }

  EditableBezierSegment(LineSegment start, LineSegment end) {
    super(start, end);
    exposedP0 = start.getP0();
    exposedC0 = start.getP1();
    exposedC1 = end.getP0();
    exposedP1 = end.getP1();
  }

  PVector getP0() {
    return exposedP0;
  }

  PVector getC0() {
    return exposedC0;
  }

  PVector getC1() {
    return exposedC1;
  }

  PVector getP1() {
    return exposedP1;
  }

  void draw(PGraphics g) {
    super.set(exposedP0, exposedC0, exposedC1, exposedP1);
    super.draw(g);
  }

  void updateFromJSONObject(JSONObject json) {
    super.updateFromJSONObject(json);
    exposedP0 = super.getP0();
    exposedC0 = super.getC0();
    exposedC1 = super.getC1();
    exposedP1 = super.getP1();
  }
}
