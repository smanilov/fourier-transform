import 'dart:math';

main(List<String> argv) {
  int n = int.parse(argv[0]);
  for (int i = 0; i < n; ++i) {
    print(sin(10000 * i * 2 * PI / n));
  }
}
