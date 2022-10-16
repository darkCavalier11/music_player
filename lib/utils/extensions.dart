extension FormatingUtility on Duration {
  String formatDurationString() {
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
