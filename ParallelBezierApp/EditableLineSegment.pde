
class EditableLineSegment extends LineSegment {
  private PVector exposedP0;
  private PVector exposedP1;
  private boolean isEditMode;
  private float handleRadius;
  private boolean isDragging0;
  private boolean isDragging1;

  EditableLineSegment() {
    init();
    exposedP0 = new PVector();
    exposedP1 = new PVector();
  }

  EditableLineSegment(
      float startX, float startY,
      float endX, float endY) {
    super(startX, startY, endX, endY);
    init();
    exposedP0 = new PVector(startX, startY);
    exposedP1 = new PVector(endX, endY);
  }

  EditableLineSegment(
      PVector start, PVector end) {
    super(start, end);
    init();
    exposedP0 = start;
    exposedP1 = end;
  }

  PVector getP0() {
    return exposedP0;
  }

  PVector getP1() {
    return exposedP1;
  }

  void init() {
    isEditMode = false;
    handleRadius = 12;
    isDragging0 = false;
    isDragging1 = false;
  }

  boolean isEditMode() {
    return isEditMode;
  }

  EditableLineSegment isEditMode(boolean v) {
    isEditMode = v;

    return this;
  }

  void draw(PGraphics g) {
    super.draw(g);

    if (isEditMode) {
      drawHandle(g, getP0());
      drawHandle(g, getP1());
    }
  }

  void positionChanged() {
    super.set(exposedP0, exposedP1);
  }

  void nudge(float x, float y) {
    exposedP0.x += x;
    exposedP0.y += y;
    exposedP1.x += x;
    exposedP1.y += y;
  }

  EditableLineSegment clone() {
    return new EditableLineSegment(exposedP0, exposedP1);
  }

  void mousePressed() {
    if (isEditMode) {
      PVector mouse = new PVector(mouseX, mouseY);
      if (hitTest(exposedP0, mouse)) {
        isDragging0 = true;
      }
      if (hitTest(exposedP1, mouse)) {
        isDragging1 = true;
      }
    }
  }

  void mouseDragged() {
    if (isEditMode) {
      if (isDragging0) {
        exposedP0.x = mouseX;
        exposedP0.y = mouseY;
        positionChanged();
      }
      if (isDragging1) {
        exposedP1.x = mouseX;
        exposedP1.y = mouseY;
        positionChanged();
      }
    }
  }

  void mouseReleased() {
    isDragging0 = false;
    isDragging1 = false;
  }

  private boolean hitTest(PVector p, PVector mouse) {
    return PVector.sub(p, mouse).mag() < handleRadius;
  }

  private void drawHandle(PGraphics g, PVector p) {
    g.ellipse(p.x, p.y, 2*handleRadius, 2*handleRadius);
  }

  void updateFromJSONObject(JSONObject json) {
    super.updateFromJSONObject(json);
    exposedP0.x = json.getJSONObject("p0").getFloat("x");
    exposedP0.y = json.getJSONObject("p0").getFloat("y");
    exposedP1.x = json.getJSONObject("p1").getFloat("x");
    exposedP1.y = json.getJSONObject("p1").getFloat("y");
  }
}
