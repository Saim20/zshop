import 'dart:math';

double roundRating(double val, int places) {
  double mod = pow(10.0, places).toDouble();
  return ((val * mod).round().toDouble() / mod);
}
