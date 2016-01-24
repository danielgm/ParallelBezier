
import java.util.Iterator;

ParallelBeziers parallelBeziers;
FileNamer fileNamer;

color strokeColor, backgroundColor0, backgroundColor1;

void setup() {
  size(640, 640, P2D);

  parallelBeziers = new ParallelBeziers();
  parallelBeziers.load("settings.json");

  strokeColor = 0xff030303;
  backgroundColor0 = 0xff69d3ce;
  backgroundColor1 = 0xff887abf;

  fileNamer = new FileNamer("output/export", "png");
}

void draw() {
  g.background(255);
  g.stroke(0);
  g.strokeWeight(2);
  g.noFill();

  parallelBeziers.draw(g);
}

void keyReleased() {
  switch (key) {
    case 'e':
      parallelBeziers.isEditMode(!parallelBeziers.isEditMode());
      break;
    case 'r':
      save(fileNamer.next());
      break;
    case 's':
      saveJSONObject(parallelBeziers.toJSONObject(), "settings.json");
      break;
  }
}

void mousePressed() {
  parallelBeziers.mousePressed();
}

void mouseDragged() {
  parallelBeziers.mouseDragged();
}

void mouseReleased() {
  parallelBeziers.mouseReleased();
}

