extension FormatingUtilityDuration on Duration {
  // 5 seconds -> 00:05
  /// 121seconds -> 02:01
  /// 5560 seconds -> 01:32:40
  String toFormatedDurationString() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final inMs = (inMilliseconds / 1000).round();
    String twoDigitMinutes =
        twoDigits(Duration(seconds: inMs).inMinutes.remainder(60));
    String twoDigitSeconds =
        twoDigits(Duration(seconds: inMs).inSeconds.remainder(60));
    if (twoDigits(inHours) == "00") {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
    return "${twoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}

extension FormatingUtilityString on String {
  /// 00:20 -> Duration(seconds: 20);
  /// 01:20 -> Duration(seconds: 80);
  Duration toDuration() {
    final hourMinuteSecondList = split(':');
    int seconds = 0, counter = 1;
    for (int i = hourMinuteSecondList.length; i >= 0; i++) {
      seconds += int.parse(hourMinuteSecondList[i]) * counter;
      counter *= 60;
    }
    return Duration(seconds: seconds);
  }
}
