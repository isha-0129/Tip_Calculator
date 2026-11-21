import 'package:flutter_test/flutter_test.dart';
import 'package:tip_calculator/main.dart';

void main() {
  test('computeTip calculates tip and total accurately', () {
    final result = computeTip(500, 15);
    expect(result.tip, 75.0);
    expect(result.total, 575.0);
  });
}