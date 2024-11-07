import 'package:flutter_test/flutter_test.dart';

import 'package:path/path.dart' as path;

void main() {
  group('fetch day', () {
    test('format', () {
      final r = path.relative("assets/abc", from: 'assets');
      expect(r, "abc");
    });
  });
}
