
class BezierSegment implements IVectorFunction {
  PVector p0, p1;
  PVector c0, c1;

  BezierSegment(
      float startX, float startY,
      float startControlX, float startControlY,
      float endControlX, float endControlY,
      float endX, float endY) {
    set(
      startX, startY, startControlX, startControlY,
      endControlX, endControlY, endX, endY);
  }

  BezierSegment(PVector start, PVector startControl, PVector endControl, PVector end) {
    set(start, startControl, endControl, end);
  }

  BezierSegment(LineSegment start, LineSegment end) {
    set(start, end);
  }

  void set(
      float startX, float startY,
      float startControlX, float startControlY,
      float endControlX, float endControlY,
      float endX, float endY) {
    p0 = new PVector(startX, startY);
    c0 = new PVector(startControlX, startControlY);
    c1 = new PVector(endControlX, endControlY);
    p1 = new PVector(endX, endY);
  }

  void set(PVector start, PVector startControl, PVector endControl, PVector end) {
    p0 = start.get();
    c0 = startControl.get();
    c1 = endControl.get();
    p1 = end.get();
  }

  void set(LineSegment start, LineSegment end) {
    p0 = start.p0.get();
    c0 = start.p1.get();
    c1 = end.p0.get();
    p1 = end.p1.get();
  }

  void draw(PGraphics g) {
    g.bezier(p0.x, p0.y, c0.x, c0.y, c1.x, c1.y, p1.x, p1.y);
  }

  /**
   * Simpler formulation of De Casteljau algorithm for cubic Béziers.
   * @see http://stackoverflow.com/a/879213
   * @author Naaff
   */
  void draw(PGraphics g, float t0, float t1) {
    float u0 = 1.0 - t0;
    float u1 = 1.0 - t1;

    float qxa = p0.x*u0*u0 + c0.x*2*t0*u0 + c1.x*t0*t0;
    float qxb = p0.x*u1*u1 + c0.x*2*t1*u1 + c1.x*t1*t1;
    float qxc = c0.x*u0*u0 + c1.x*2*t0*u0 + p1.x*t0*t0;
    float qxd = c0.x*u1*u1 + c1.x*2*t1*u1 + p1.x*t1*t1;

    float qya = p0.y*u0*u0 + c0.y*2*t0*u0 + c1.y*t0*t0;
    float qyb = p0.y*u1*u1 + c0.y*2*t1*u1 + c1.y*t1*t1;
    float qyc = c0.y*u0*u0 + c1.y*2*t0*u0 + p1.y*t0*t0;
    float qyd = c0.y*u1*u1 + c1.y*2*t1*u1 + p1.y*t1*t1;

    float xa = qxa*u0 + qxc*t0;
    float xb = qxa*u1 + qxc*t1;
    float xc = qxb*u0 + qxd*t0;
    float xd = qxb*u1 + qxd*t1;

    float ya = qya*u0 + qyc*t0;
    float yb = qya*u1 + qyc*t1;
    float yc = qyb*u0 + qyd*t0;
    float yd = qyb*u1 + qyd*t1;

    g.bezier(xa, ya, xb, yb, xc, yc, xd, yd);
  }

  void drawControls(PGraphics g) {
    g.line(p0.x, p0.y, c0.x, c0.y);
    g.line(p1.x, p1.y, c1.x, c1.y);
  }

  PVector getPoint(float t) {
    return new PVector(
      bezierInterpolation(p0.x, c0.x, c1.x, p1.x, t),
      bezierInterpolation(p0.y, c0.y, c1.y, p1.y, t));
  }

  /**
   * @see http://stackoverflow.com/a/4060392
   * @author michal@michalbencur.com
   */
  private float bezierInterpolation(float a, float b, float c, float d, float t) {
    float t2 = t * t;
    float t3 = t2 * t;
    return a + (-a * 3 + t * (3 * a - a * t)) * t
    + (3 * b + t * (-6 * b + b * 3 * t)) * t
    + (c * 3 - c * 3 * t) * t2
    + d * t3;
  }
}
