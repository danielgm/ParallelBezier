
import java.util.Iterator;

int drawingWidth;
int drawingHeight;
int drawingOffsetX;
int drawingOffsetY;
Drawing drawing;
FileNamer fileNamer;

void setup() {
  size(1440, 820, P2D);

  drawingWidth = 640;
  drawingHeight = 640;
  drawingOffsetX = floor((width - drawingWidth) / 2);
  drawingOffsetY = floor((height - drawingHeight) / 2);

  drawing = new Drawing();
  drawing.load("settings.json");

  fileNamer = new FileNamer("output/export", "png");
}

void draw() {
  draw(g, true);
}

void draw(PGraphics g) {
  draw(g, false);
}

void draw(PGraphics g, boolean workarea) {
  if (workarea) {
    g.background(196);

    g.noStroke();
    g.fill(0);
    g.rect(drawingOffsetX, drawingOffsetY, drawingWidth, drawingHeight);
  }
  else {
    g.background(0);
  }

  g.pushMatrix();
  g.pushStyle();

  g.stroke(255);
  g.strokeWeight(2);
  g.noFill();

  if (workarea) {
    g.translate(drawingOffsetX, drawingOffsetY);
  }

  drawing.draw(g);

  g.popStyle();
  g.popMatrix();
}

void keyReleased() {
  switch (key) {
    case 'e':
      drawing.isEditMode(!drawing.isEditMode());
      break;
    case 'r':
      render(fileNamer.next());
      break;
    case 's':
      saveJSONObject(drawing.toJSONObject(), "settings.json");
      break;
    case 'd':
      drawing.prevEditingIndex();
      break;
    case 'f':
      drawing.nextEditingIndex();
      break;
  }
}

void mousePressed() {
  mouseX -= drawingOffsetX;
  mouseY -= drawingOffsetY;

  drawing.mousePressed();
}

void mouseDragged() {
  mouseX -= drawingOffsetX;
  mouseY -= drawingOffsetY;

  drawing.mouseDragged();
}

void mouseReleased() {
  mouseX -= drawingOffsetX;
  mouseY -= drawingOffsetY;

  drawing.mouseReleased();
}

void render(String path) {
  PGraphics render = createGraphics(drawingWidth, drawingHeight, P3D);
  render.beginDraw();
  draw(render);
  render.endDraw();
  render.save(path);
}

