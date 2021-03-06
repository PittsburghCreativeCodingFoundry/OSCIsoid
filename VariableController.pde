import java.awt.Rectangle;

class VariableController<T> {
  PVector momentum;
  T value;
  public String name;
  float drag;

  public VariableController(String name, T def, float drag) {
    this.name = name;
    this.value = def;
    this.drag = drag;
    momentum = new PVector(0,0);
  }

  public void hit(PVector hit) {
    momentum.add(hit);
  };

  public void set(PShader ps) {};
}

class FloatController extends VariableController<Float> {
  float lowerBound, upperBound;

  public FloatController(String name, Float def, 
      float drag, float lowerBound, float upperBound) {
    super(name, def, drag);
    this.lowerBound = lowerBound;
    this.upperBound = upperBound;
  }

  void set(PShader ps) {
    value += momentum.mag();
    if (value < lowerBound || value > upperBound) {
      value = constrain(value, lowerBound, upperBound);
      momentum.rotate(PI); //bounce!
    }
    ps.set(name, value);
    momentum.mult(drag);
  }
}

class VectorController extends VariableController<PVector> {
  Rectangle bounds;
  public VectorController(String name, PVector def, float drag, 
      Rectangle bounds) { 
    super(name, def, drag);
    this.bounds = bounds;
  }

  void set(PShader ps) {
    value.add(momentum);
    if (!bounds.contains(value.x, value.y)) {
      momentum.rotate(PI);
    }
    ps.set(name, value);
    momentum.mult(drag);
  }
}

class WeightController extends FloatController {
  public WeightController(String name) {
    super(name, 0.0, 0.98, 0.0, 1.0);
  }
}

class PositionController extends VectorController {
  public PositionController(String name, float drag) {
    super(name, new PVector(35, 35), drag, 
      new Rectangle(0,0,90,90));
  }
}