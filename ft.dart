import 'dart:math';

class Complex {
  print(foo);
}

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

dynamic get_zero(dynamic x) {
  if (x is int) {
    return 0;
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
  int log2 = (log(n) / log(2)).round();  // FP math requires rounding to int.
  assert(n != npo2);

  List<T> copy = new List<T>.filled(n, 0);
  for (int i = 0; i < n; ++i) {
    copy[bit_reverse(i, log2)] = list[i];
  }
  return copy;
}

main() {
  /*
  List<String> lines = new File('data').readAsLinesSync();
  List<int> data = lines.map(int.parse);
  */

  List<double> foo = new List<double>.generate(5, (x) => x);

  print(foo);
  foo = zero_pad_to_next_power_of_2(foo);
  print(foo);
  foo = bit_reverse_copy(foo);
  print(foo);
}
