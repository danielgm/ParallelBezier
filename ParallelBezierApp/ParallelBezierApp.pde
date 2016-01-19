
import java.util.Iterator;

ArrayList<EditableLineSegment> segments;
ArrayList<EditableBezierSegment> beziers;

FileNamer fileNamer;

color strokeColor, backgroundColor0, backgroundColor1;

void setup() {
  size(640, 640, P2D);

  segments = new ArrayList<EditableLineSegment>();
  beziers = new ArrayList<EditableBezierSegment>();
  createSegments();

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

