import 'package:flutter_test/flutter_test.dart';
import 'package:music_player/utils/extensions.dart';

void main() {
  group('Test Duration utility', () {
    test('toFormattedDurationString', () {
      const d1 = Duration(seconds: 60);
      expect(d1.toFormatedDurationString(), "01:00");

      const d2 = Duration(seconds: 119);
      expect(d2.toFormatedDurationString(), "01:59");

      const d3 = Duration(seconds: 19);
      expect(d3.toFormatedDurationString(), "00:19");

      const d4 = Duration(minutes: 63, seconds: 14);
      expect(d4.toFormatedDurationString(), "01:03:14");

    });
  });
}
