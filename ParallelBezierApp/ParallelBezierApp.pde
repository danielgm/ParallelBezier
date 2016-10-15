
import java.util.Iterator;

int drawingWidth;
int drawingHeight;
int drawingOffsetX;
int drawingOffsetY;
Drawing drawing;
FileNamer fileNamer;

float backgroundScale;
PImage background;

void setup() {
  size(1440, 820, P2D);
  
  backgroundScale = 0.3;
  background = loadImage("background.jpg");

  drawingWidth = floor(background.width * backgroundScale);
  drawingHeight = floor(background.height * backgroundScale);
  drawingOffsetX = floor((width - drawingWidth) / 2);
  drawingOffsetY = floor((height - drawingHeight) / 2);

  drawing = new Drawing(drawingWidth, drawingHeight);
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
    
    g.image(background, drawingOffsetX, drawingOffsetY, drawingWidth, drawingHeight);
  }
  else {
    g.background(0);
    g.image(background, 0, 0, drawingWidth, drawingHeight);
  }
  
  g.pushMatrix();
  g.pushStyle();
  
  g.bezierDetail(200);
  
  g.strokeWeight(1);
  g.noFill();
  g.blendMode(DARKEST);

  if (workarea) {
    g.translate(drawingOffsetX, drawingOffsetY);
  }

  drawing.draw(g);

  if (workarea) {
    g.translate(-drawingOffsetX, -drawingOffsetY);
    
    g.noFill();
    g.strokeWeight(1);
    g.stroke(255);
    g.rect(drawingOffsetX, drawingOffsetY, drawingWidth, drawingHeight);
  }
  
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
    case 't':
      drawing.duplicate();
      break;
    case 'd':
      drawing.prevEditingIndex();
      break;
    case 'f':
      drawing.nextEditingIndex();
      break;
    case 'x':
      drawing.randomize();
      break;
  }
  switch (keyCode) {
    case UP:
      drawing.nudge(0, -0.5);
      break;
    case DOWN:
      drawing.nudge(0, 0.5);
      break;
    case LEFT:
      drawing.nudge(-0.5, 0);
      break;
    case RIGHT:
      drawing.nudge(0.5, 0);
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
  draw(render, false);
  render.endDraw();
  render.save(path);
}