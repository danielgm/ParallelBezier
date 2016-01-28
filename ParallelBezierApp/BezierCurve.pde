
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;

class BezierCurve implements IVectorFunction {
  private int POLYLINE_POINTS_PER_CONTROL = 100;

  private ArrayList<LineSegment> controls;

  private int numPolylinePoints;
  private float polylineLength;
  private float[] polylineTimes;
  private float[] polylineLengths;
  private float[] segmentLengths;

  BezierCurve() {
    controls = new ArrayList<LineSegment>();

    numPolylinePoints = 0;
    polylineLength = 0;
  }

  void draw(PGraphics g) {
    LineSegment line0, line1;
    for (int i = 0; i < controls.size () - 1; i++) {
      line0 = controls.get(i);
      line1 = controls.get(i + 1);

      if (i == 0) {
        g.bezier(
          line0.p0.x, line0.p0.y, line0.p1.x, line0.p1.y,
          line1.p0.x, line1.p0.y, line1.p1.x, line1.p1.y);
      } else {
        g.bezier(
          line0.p1.x, line0.p1.y, 2 * line0.p1.x - line0.p0.x, 2 * line0.p1.y - line0.p0.y,
          line1.p0.x, line1.p0.y, line1.p1.x, line1.p1.y);
      }
    }
  }

  void draw(PGraphics g, float t0, float t1) {
    LineSegment line0, line1;
    float dist0 = t0 * polylineLength;
    float dist1 = t1 * polylineLength;
    float segmentDistance = 0, nextSegmentDistance = segmentLengths[0];
    int numSegments = controls.size() - 1;
    float u0, u1;

    // FIXME: Inefficient to instantiate a BezierSegment during draw.
    BezierSegment bs;

    float nextPolylineDist, polylineDist = 0;
    for (int i = 0; i < numPolylinePoints - 1; i++) {
      nextPolylineDist = polylineDist + polylineLengths[i];
      if (dist0 > polylineDist) {
        t0 = (dist0 - polylineDist) / polylineLengths[i];
        t0 = (t0 + i) / (numPolylinePoints - 1);
      }
      if (dist1 > polylineDist) {
        t1 = (dist1 - polylineDist) / polylineLengths[i];
        t1 = (t1 + i) / (numPolylinePoints - 1);
      }
      polylineDist += polylineLengths[i];
    }

    for (int i = floor(t0 * numSegments); i < floor(t1 * numSegments) + 1 && i < numSegments; i++) {
      line0 = controls.get(i);
      line1 = controls.get(i + 1);

      u0 = constrain((t0 - (float)i / numSegments) * numSegments, 0, 1);
      u1 = constrain((t1 - (float)i / numSegments) * numSegments, 0, 1);

      if (i == 0) {
        bs = new BezierSegment(
          line0.p0.x, line0.p0.y, line0.p1.x, line0.p1.y,
          line1.p0.x, line1.p0.y, line1.p1.x, line1.p1.y);
      } else {
        bs = new BezierSegment(
          line0.p1.x, line0.p1.y, 2 * line0.p1.x - line0.p0.x, 2 * line0.p1.y - line0.p0.y,
          line1.p0.x, line1.p0.y, line1.p1.x, line1.p1.y);
      }
      bs.draw(g, u0, u1);
    }
  }

  int numControls() {
    return controls.size();
  }

  BezierSegment getSegment(int i) {
    if (i < 0 || i + 1 >= controls.size()) return null;
    return new BezierSegment(controls.get(i), controls.get(i + 1));
  }

  void addControl(LineSegment control) {
    controls.add(control.clone());
    recalculate();
  }

  ArrayList<LineSegment> controls() {
    return new ArrayList<LineSegment>(controls);
  }

  BezierCurve controls(ArrayList<LineSegment> newControls) {
      controls = new ArrayList<LineSegment>(newControls);
      return this;
  }

  void drawControls(PGraphics g) {
    LineSegment line;
    for (int i = 0; i < controls.size (); i++) {
      line = controls.get(i);
      g.line(line.p0.x, line.p0.y, line.p1.x, line.p1.y);

      if (i > 0 && i < controls.size() - 1) {
        g.line(line.p1.x, line.p1.y, 2 * line.p1.x - line.p0.x, 2 * line.p1.y - line.p0.y);
      }
    }
  }

  float getLength() {
    if (controls.size() < 2) return 0;

    // FIXME: Use uniform arc-distance points for better accuracy.
    return polylineLength;
  }

  PVector getPoint(float t) {
    if (controls.size() < 2) return null;
    if (t <= 0) return controls.get(0).p0.get();
    if (t >= 1) return controls.get(controls.size() - 1).p1.get();

    float polylineDistance = 0;
    for (int i = 0; i < numPolylinePoints - 1; i++) {
      if (t * polylineLength < polylineDistance + polylineLengths[i]) {
        float k = (t * polylineLength - polylineDistance) / polylineLengths[i];
        float u = polylineTimes[i] + k * (polylineTimes[i + 1] - polylineTimes[i]);

        return getPointOnCurveNaive(u);
      }
      polylineDistance += polylineLengths[i];
    }

    return null;
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

  private int getPointOnCurveNaiveIndex(float t) {
    if (controls.size() < 1) return -1;
    int len = controls.size() - 1;
    int index = floor(t * len);
    return index;
  }

  private PVector getPointOnCurveNaive(float t) {
    if (controls.size() < 2) return null;
    if (t <= 0) return controls.get(0).p0.get();
    if (t >= 1.0) return controls.get(controls.size() - 1).p1.get();

    int len = controls.size() - 1;
    int index = floor(t * len);
    float u = (t * len - index);
    LineSegment line0 = controls.get(index);
    LineSegment line1 = controls.get(index + 1);
    if (index == 0) {
      return new PVector(
        bezierInterpolation(line0.p0.x, line0.p1.x, line1.p0.x, line1.p1.x, u),
        bezierInterpolation(line0.p0.y, line0.p1.y, line1.p0.y, line1.p1.y, u));
    } else {
      return new PVector(
        bezierInterpolation(line0.p1.x, 2 * line0.p1.x - line0.p0.x, line1.p0.x, line1.p1.x, u),
        bezierInterpolation(line0.p1.y, 2 * line0.p1.y - line0.p0.y, line1.p0.y, line1.p1.y, u));
    }
  }

  private void recalculate() {
    if (controls.size() < 2) return;

    numPolylinePoints = controls.size() * POLYLINE_POINTS_PER_CONTROL;
    PVector[] polylinePoints = new PVector[numPolylinePoints];
    int[] polylineControlIndices = new int[numPolylinePoints];
    polylineTimes = new float[numPolylinePoints];
    polylineLengths = new float[numPolylinePoints - 1];
    polylineLength = 0;
    segmentLengths = new float[controls.size()];
    int polylineControlIndex, prevPolylineControlIndex = -1;
    PVector d;

    for (int i = 0; i < numPolylinePoints; i++) {
      polylineTimes[i] = (float)i / (numPolylinePoints - 1);
      polylinePoints[i] = getPointOnCurveNaive(polylineTimes[i]);
      polylineControlIndex = polylineControlIndices[i] = getPointOnCurveNaiveIndex(polylineTimes[i]);

      if (i > 0) {
        d = polylinePoints[i].get();
        d.sub(polylinePoints[i - 1]);
        polylineLengths[i - 1] = d.mag();
        polylineLength += d.mag();

        if (prevPolylineControlIndex < polylineControlIndex) {
          segmentLengths[polylineControlIndex] = d.mag();
        } else {
          segmentLengths[polylineControlIndex] += d.mag();
        }
        prevPolylineControlIndex = polylineControlIndex;
      } else {
        polylineLengths[i] = 0;
      }
    }
  }

  JSONObject toJSONObject() {
    JSONArray jsonControls = new JSONArray();
    for (int i = 0; i < controls.size(); i++) {
      LineSegment control = controls.get(i);
      jsonControls.setJSONObject(i, control.toJSONObject());
    }

    JSONObject json = new JSONObject();
    json.setJSONArray("controls", jsonControls);
    json.setInt("numPolylinePoints", numPolylinePoints);
    json.setFloat("polylineLength", polylineLength);
    return json;
  }

  void updateFromJSONObject(JSONObject json) {
    controls = new ArrayList<LineSegment>();
    JSONArray jsonControls = json.getJSONArray("controls");
    for (int i = 0; i < jsonControls.size(); i++) {
      LineSegment segment = new LineSegment();
      segment.updateFromJSONObject(jsonControls.getJSONObject(i));
      controls.add(segment);
    }
  }
}

