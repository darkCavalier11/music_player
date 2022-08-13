extension FormatingUtility on Duration {
  String formatDurationString() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(inSeconds.remainder(60));
    if (twoDigits(inHours) == "00") {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
    return "${twoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
