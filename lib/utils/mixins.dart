mixin AppUtilityMixin {
  // convert duration to readable string
  // 65s = 01:05
  String convertDurationToString(Duration duration) {
    int inSeconds = duration.inSeconds;
    var durString = <String>[];
    while (inSeconds > 0) {
      int rem = inSeconds % 60;
      if (rem < 10) {
        durString.add('0$rem');
      } else {
        durString.add('$rem');
      }
      inSeconds ~/= 60;
    }
    return durString.reversed.join(':');
  }
}
