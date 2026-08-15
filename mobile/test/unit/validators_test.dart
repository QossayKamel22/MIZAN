import 'package:flutter_test/flutter_test.dart';
import 'package:mizan/core/utils/validators.dart';

void main() {
  group('Validators.amount', () {
    test('rejects empty input', () {
      expect(Validators.amount(''), isNotNull);
    });
    test('rejects zero and negative', () {
      expect(Validators.amount('0'), isNotNull);
      expect(Validators.amount('-5'), isNotNull);
    });
    test('accepts positive numeric input', () {
      expect(Validators.amount('150.50'), isNull);
    });
  });

  group('Validators.email', () {
    test('rejects malformed email', () {
      expect(Validators.email('not-an-email'), isNotNull);
    });
    test('accepts well-formed email', () {
      expect(Validators.email('user@example.com'), isNull);
    });
  });
}
