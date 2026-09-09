// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:calculator/main.dart';

void main() {
  test('Prioritas operasi dan kiri-kanan sesuai kalkulator', () {
    expect(hitungEkspresi('-6+(-65)'), equals(-71));
    expect(hitungEkspresi('2(3+4)'), equals(14));
    expect(hitungEkspresi('(2+3)*4'), equals(20));
    expect(hitungEkspresi('8/4*2'), equals(4));
    expect(hitungEkspresi('10-3-2'), equals(5));
    expect(hitungEkspresi('2+3*4'), equals(14));
  });
}
