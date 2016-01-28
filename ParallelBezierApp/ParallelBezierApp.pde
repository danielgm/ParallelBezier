
import java.util.Iterator;

Drawing drawing;
FileNamer fileNamer;

void setup() {
  size(640, 640, P2D);

  drawing = new Drawing();
  drawing.load("settings.json");

  fileNamer = new FileNamer("output/export", "png");
}

void draw() {
  g.background(255);
  g.stroke(0);
  g.strokeWeight(2);
  g.noFill();

  drawing.draw(g);
}

void keyReleased() {
  switch (key) {
    case 'e':
      drawing.isEditMode(!drawing.isEditMode());
      break;
    case 'r':
      save(fileNamer.next());
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
