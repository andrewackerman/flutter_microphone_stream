import 'dart:math' as Math;

export 'dart:math';

double abs(double a) {
  if (a < 0)
    return -a;
  return a;
}

// Hyperbolic trig functions

double sinh(double a) {
  return (Math.pow(Math.e, a) - Math.pow(Math.e, -a)) / 2.0;
}

double cosh(double a) {
  return (Math.pow(Math.e, a) + Math.pow(Math.e, -a)) / 2.0;
}

double tanh(double a) {
  return sinh(a) / cosh(a);
}