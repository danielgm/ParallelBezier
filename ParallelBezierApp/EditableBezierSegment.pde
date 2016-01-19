
class EditableBezierSegment extends BezierSegment {
  private PVector exposedStart;
  private PVector exposedStartControl;
  private PVector exposedEndControl;
  private PVector exposedEnd;

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
    exposedStart = start;
    exposedStartControl = startControl;
    exposedEndControl = endControl;
    exposedEnd = end;
  }

  EditableBezierSegment(LineSegment start, LineSegment end) {
    super(start, end);
    exposedStart = start.p0;
    exposedStartControl = start.p1;
    exposedEndControl = end.p0;
    exposedEnd = end.p1;
  }

  void draw(PGraphics g) {
    super.set(exposedStart, exposedStartControl, exposedEndControl, exposedEnd);
    super.draw(g);
  }
}
