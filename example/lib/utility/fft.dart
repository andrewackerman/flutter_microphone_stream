import 'dart:math' as Math;

import 'package:microphone_stream_example/utility/complex_numbers.dart';

class _Ref<T> {
  T value;
  _Ref(this.value);
}

class FFT {
  List<Complex> x;
  List<Complex> X;

  FFT(int n) {
    x = List(n);
    X = List(n);
    fill();

    var ref = _Ref(X);
    fft2(ref, 0, n);
    X = ref.value;
  }

  void separate(_Ref<List<Complex>> a, int m, int n) {
    List<Complex> b = List((n - m ~/ 2));
    for (int i = 0; i < (n - m) ~/ 2; i++)
      b[i] = a.value[m + i * 2 + 1];
    for (int i = 0; i < (n - m) ~/ 2; i++)
      a.value[m + i] = a.value[m + i * 2];
    for (int i = 0; i < (n - m) ~/ 2; i++) 
      a.value[m + i + (n - m) ~/ 2] = b[i];
  }

  void fft2(_Ref<List<Complex>> X, int m, int n) {
    if (n - m >= 2) {
      separate(X, m, n);
      fft2(X, m, m + (n - m) ~/ 2);
      fft2(X, m + (n - m) ~/ 2, n);
      for (int k = 0; k < (n - m) ~/ 2; k++) {
        Complex e = X.value[m + k];
        Complex o = X.value[m + k + (n - m) ~/ 2];
        Complex w = Complex.exp(Complex(0.0, -2 * Math.pi * k / (n - m)));
        X.value[m + k] = e + w * o;
        X.value[m + k + (n - m) ~/ 2] = e - w * o;
      }
    }
  }

  double signal(double t) {
    const List<double> freq = [ 2.0, 5.0, 11.0, 17.0, 29.0 ];
    double sum = 0.0;
    for (int j = 0; j < freq.length; j++) {
      sum += Math.sin(2 * Math.pi * freq[j] * t);
    }
    return sum;
  }

  void fill() {
    int N = x.length;
    for (int i = 0; i < N; i++) {
      x[i] = Complex.fromDouble((i.toDouble() / N));
      X[i] = x[i];
    }
  }
}