import 'math_ext.dart' as Math;

class Complex {
  // Data and getter wrappers

  final double _r;
  double get real => _r;

  final double _i;
  double get imaginary => _i;

  // Necessary constants

  static const double _log10Inv = 0.43429448190325;

  // Generated getters

  double get magnitude => Complex.abs(this);
  double get phase => Math.atan2(_i, _r);

  // Attributes

  static const Complex zero = const Complex(0.0, 0.0);
  static const Complex one = const Complex(1.0, 0.0);
  static const Complex imaginaryOne = const Complex(0.0, 1.0);

  // Constructors and factories

  const Complex(this._r, this._i);
  const Complex.fromInt(int val) : this(val + 0.0, 0.0);
  const Complex.fromDouble(double val) : this(val, 0.0);

  static Complex fromPolarCoordinates(double magnitude, double phase) {
    return Complex(magnitude * Math.cos(phase), magnitude * Math.sin(phase));
  }

  static Complex negate(Complex val) {
    return -val;
  }

  static Complex add(Complex left, Complex right) {
    return left + right;
  }

  static Complex subtract(Complex left, Complex right) {
    return left - right;
  }

  static Complex multiply(Complex left, Complex right) {
    return left * right;
  }

  static Complex divide(Complex dividend, Complex divisor) {
    return dividend / divisor;
  }

  // Arithmetic operator overloading

  //Unary
  Complex operator -() => Complex(-_r, -_i);

  //Binary
  Complex operator +(Complex val) => Complex(_r + val._r, _i + val._i);
  Complex operator -(Complex val) => Complex(_r - val._r, _i - val._i);
  Complex operator *(Complex val) =>
      Complex(_r * val._r - _i * val._i, _r * val._i + _i * val._r);
  Complex operator /(Complex val) {
    var a = _r;
    var b = _i;
    var c = val._r;
    var d = val._i;

    if (Math.abs(d) < Math.abs(c)) {
      double doc = d / c;
      return Complex(
          (a + b * doc) / (c + d * doc), (b - a * doc) / (c + d * doc));
    } else {
      double cod = c / d;
      return Complex(
          (b + a * cod) / (d + c * cod), (-a + b * cod) / (d + c * cod));
    }
  }

  // Other arithmetic operations

  static double abs(Complex val) {
    if (val._r == double.infinity || val._i == double.infinity) {
      return double.infinity;
    }

    double ra = Math.abs(val._r);
    double ia = Math.abs(val._i);

    if (ra > ia) {
      double r = ia / ra;
      return ra * Math.sqrt(1.0 + r * r);
    } else if (ia == 0.0) {
      return ra;
    } else {
      double r = ra / ia;
      return ia * Math.sqrt(1.0 + r * r);
    }
  }

  static Complex conjugate(Complex val) {
    return Complex(val._r, -val._i);
  }

  static Complex reciprocal(Complex val) {
    if (val._r == 0 && val._i == 0) {
      return Complex.zero;
    }

    return Complex.one / val;
  }

  // Comparison operator overloading

  bool operator ==(dynamic c) {
    if (c is Complex) {
      return _r == c._r && _i == c._i;
    }
    return false;
  }

  // Formatting/parsing options

  @override
  String toString() {
    return "($_r, $_i)";
  }

  @override
  int get hashCode {
    int n1 = 99999997;
    int hashReal = _r.hashCode % n1;
    int hashImaginary = _i.hashCode;
    int hash = hashReal ^ hashImaginary;
    return hash;
  }

  // Trigonometric operations

  static Complex sin(Complex val) {
    double a = val._r;
    double b = val._i;
    return Complex(Math.sin(a) * Math.cosh(b), Math.cos(a) * Math.sinh(b));
  }

  static Complex sinh(Complex val) {
    double a = val._r;
    double b = val._i;
    return Complex(Math.sinh(a) * Math.cos(b), Math.cosh(a) * Math.sin(b));
  }

  static Complex asin(Complex val) {
    return (-imaginaryOne) * log(imaginaryOne * val + sqrt(one - val * val));
  }

  static Complex cos(Complex val) {
    double a = val._r;
    double b = val._i;
    return Complex(Math.cos(a) * Math.cosh(b), -(Math.sin(a) * Math.sinh(b)));
  }

  static Complex cosh(Complex val) {
    double a = val._r;
    double b = val._i;
    return Complex(Math.cosh(a) * Math.cos(b), Math.sinh(a) * Math.sin(b));
  }

  static Complex acos(Complex val) {
    return (-imaginaryOne) * log(val + imaginaryOne * sqrt(one - val * val));
  }

  static Complex tan(Complex val) {
    return sin(val) / cos(val);
  }

  static Complex tanh(Complex val) {
    return sinh(val) / cosh(val);
  }

  static Complex atan(Complex val) {
    const Complex two = Complex(2.0, 0.0);
    return (imaginaryOne / two) *
        (log(one - imaginaryOne * val) - log(one + imaginaryOne * val));
  }

  // Other numerical functions

  static Complex log(Complex val) {
    return Complex(Math.log(abs(val)), Math.atan2(val._i, val._r));
  }

  static Complex logBase(Complex val, double base) {
    return log(val) / Complex.fromDouble(Math.log(base));
  }

  static Complex log10(Complex val) {
    Complex t = log(val);
    return _scale(t, _log10Inv);
  }

  static Complex exp(Complex val) {
    double t = Math.exp(val._r);
    double re = t * Math.cos(val._i);
    double im = t * Math.sin(val._i);
    return Complex(re, im);
  }

  static Complex sqrt(Complex val) {
    return Complex.fromPolarCoordinates(
        Math.sqrt(val.magnitude), val.phase / 2.0);
  }

  static Complex pow(Complex val, double power) {
    return powComplex(val, Complex.fromDouble(power));
  }

  static Complex powComplex(Complex val, Complex power) {
    if (power == zero) {
      return one;
    }

    if (val == zero) {
      return zero;
    }

    double a = val._r;
    double b = val._i;
    double c = power._r;
    double d = power._i;

    double rho = abs(val);
    double theta = Math.atan2(b, a);
    double newRho = c * theta + d * Math.log(rho);

    double t = Math.pow(rho, c) * Math.pow(Math.e, -d * theta);

    return Complex(t * Math.cos(newRho), t * Math.sin(newRho));
  }

  // Private functions for internal use

  static Complex _scale(Complex val, double factor) {
    return Complex(val._r * factor, val._i * factor);
  }
}
