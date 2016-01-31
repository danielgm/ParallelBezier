
import java.util.Iterator;

int drawingWidth;
int drawingHeight;
Drawing drawing;
FileNamer fileNamer;

void setup() {
  size(1440, 820, P2D);

  drawingWidth = 640;
  drawingHeight = 640;

  drawing = new Drawing();
  drawing.load("settings.json");

  fileNamer = new FileNamer("output/export", "png");
}

void draw() {
  g.background(196);

  g.noStroke();
  g.fill(255);
  g.rect((width - drawingWidth) / 2, (height - drawingHeight) / 2, drawingWidth, drawingHeight);

  g.stroke(0);
  g.strokeWeight(2);
  g.noFill();

  g.pushMatrix();
  g.translate((width - drawingWidth) / 2, (height - drawingHeight) / 2);
  drawing.draw(g);
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
  drawing.mousePressed();
}

void mouseDragged() {
  drawing.mouseDragged();
}

void mouseReleased() {
  drawing.mouseReleased();
}

void render(String path) {
  PGraphics render = createGraphics(drawingWidth, drawingHeight, P3D);
  render.beginDraw();
  render.background(255);
  drawing.draw(render);
  render.endDraw();
  render.save(path);
}

