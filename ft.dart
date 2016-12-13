import 'dart:io';
import 'dart:async';
import 'dart:math';

class Complex {
  num real;
  num imaginary;

  Complex(this.real, this.imaginary);

  Complex operator +(Complex other) {
    return new Complex(real + other.real, imaginary + other.imaginary);
  }

  Complex operator -(Complex other) {
    return new Complex(real - other.real, imaginary - other.imaginary);
  }

  Complex operator *(Complex other) {
    return new Complex(
        real * other.real - imaginary * other.imaginary,
        real * other.imaginary + imaginary * other.real);
  }

  Complex abs() {
    return sqrt(real * real + imaginary * imaginary);
  }

  static Complex exp(num multiplier_of_i) {
    return new Complex(cos(multiplier_of_i), sin(multiplier_of_i));
  }

  String toString() {
    return "($real, $imaginary)";
  }
}

const IMAGINARY_UNIT = new Complex(0, 1);

// s is the maximum number of bits to consider.
// e.g. bit_reverse(1, 10) = 512
// e.g. bit_reverse(2, 2) = 1
// e.g. bit_reverse(1024, 12) = 2
// e.g. bit_reverse(5, 4) = 10
// 1 followed by 10 zeroes is 1024; has 11 bits.
int bit_reverse(int x, int s) {
  int answ = 0;
  for (int i = 0; i < s; ++i) {
    answ <<= 1;
    answ += ((x >> i) & 1);
  }
  return answ;
}

int next_power_of_two(int x) {
  return pow(2, (log(x) / log(2)).ceil());
}

int previous_power_of_two(int x) {
  return pow(2, (log(x) / log(2)).floor());
}

dynamic get_zero(dynamic x) {
  if (x is int) {
    return 0;
  } else if (x is Complex) {
    return new Complex(0, 0);
  }
  throw "not implemented";
}

// Asserts that length of input is at least one.
List<T> zero_pad_to_next_power_of_2(List<T> list) {
  int n = list.length;
  assert(n > 0);
  int npo2 = next_power_of_two(n);
  T zero = get_zero(list[0]);
  List<T> padded = new List<T>.filled(npo2, zero);
  for (int i = 0; i < n; ++i) {
    padded[i] = list[i];
  }
  return padded;
}

// Asserts that length of input is at least one.
List<T> truncate_to_previous_power_of_2(List<T> list) {
  int n = list.length;
  assert(n > 0);
  int ppo2 = previous_power_of_two(n);
  return list.sublist(0, ppo2);
}

int log2(int x) {
  return (log(x) / log(2)).round();  // FP math requires rounding to int.
}

/*
 * algorithm bit-reverse-copy(a,A) is
 *    input: Array a of n complex values where n is a power of 2,
 *    output: Array A of size n
 *
 *    n ← a.length
 *    for k = 0 to n - 1
 *        A[rev(k)] = a[k]
 *
 * ref: https://en.wikipedia.org/wiki/Cooley%E2%80%93Tukey_FFT_algorithm
*/
// Asserts that the length of the input is a power of two.
List<T> bit_reverse_copy(List<T> list) {
  int n = list.length;
  int npo2 = next_power_of_two(n);
  int log2n = log2(n);
  assert(n != npo2);

  List<T> copy = new List<T>.filled(n, 0);
  for (int i = 0; i < n; ++i) {
    copy[bit_reverse(i, log2n)] = list[i];
  }
  return copy;
}

/*
 * algorithm iterative-fft is
 *     input: Array a of n complex values where n is a power of 2
 *     output: Array A the DFT of a
 *
 *     bit-reverse-copy(a,A)
 *     n ← a.length
 *     for s = 1 to log(n)
 *         m ← 2^s
 *         ω_m ← exp(−2πi/m)
 *         for k = 0 to n-1 by m
 *             ω ← 1
 *             for j = 0 to m/2 - 1
 *                 t ← ω A[k + j + m/2]
 *                 u ← A[k + j
 *                 A[k + j] ← u + t
 *                 A[k + j + m/2] = u - t
 *                 ω ← ω ω_m
 *
 *     return A
*/
List<Complex> iterative_fft(List<Complex> list) {
  List<Complex> brc = bit_reverse_copy(list);
  int n = list.length;
  int log2n = log2(n);
  int m = 1;
  for (int s = 0; s < log2n; ++s) {
    m <<= 1;
    Complex omega_m = Complex.exp(-2 * PI / m);
    for (int k = 0; k < n; k += m) {
      Complex omega = new Complex(1, 0);
      for (int j = 0; j < m/2; ++j) {
        Complex t = omega * brc[k + j + m~/2];
        Complex u = brc[k + j];
        brc[k + j] = u + t;
        brc[k + j + m~/2] = u - t;
        omega *= omega_m;
      }
    }
  }

  return brc;
}

main() async {
  List<String> lines = new File('data').readAsLinesSync();
  List<Complex> data = lines.map((x) => new Complex(num.parse(x), 0)).toList();
  List<Complex> fft = iterative_fft(truncate_to_previous_power_of_2(data));
  List<num> amounts = fft.map((x) => x.abs());

  var writes = new List<Future>();
  writes.add(new File('fft').writeAsString(fft.join("\n")));
  writes.add(new File('spectrum').writeAsString(amounts.join("\n")));
  Future.wait(writes);
}
