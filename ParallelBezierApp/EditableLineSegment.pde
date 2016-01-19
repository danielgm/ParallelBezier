
class EditableLineSegment extends LineSegment {
  boolean isEditMode;
  float handleRadius;
  boolean isDragging0;
  boolean isDragging1;

  EditableLineSegment(
      float startX, float startY,
      float endX, float endY) {
    super(startX, startY, endX, endY);
    init();
  }

  EditableLineSegment(
      PVector start, PVector end) {
    super(start, end);
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

  void isEditMode(boolean v) {
    isEditMode = v;
  }

  void draw(PGraphics g) {
    super.draw(g);

    if (isEditMode) {
      drawHandle(g, p0);
      drawHandle(g, p1);
    }
  }

  void mousePressed() {
    PVector mouse = new PVector(mouseX, mouseY);
    if (hitTest(p0, mouse)) {
      isDragging0 = true;
    }
    if (hitTest(p1, mouse)) {
      isDragging1 = true;
    }
  }

  void mouseDragged() {
    if (isDragging0) {
      p0.x = mouseX;
      p0.y = mouseY;
    }
    if (isDragging1) {
      p1.x = mouseX;
      p1.y = mouseY;
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
}
