Map<String, dynamic> relevantTimeSince(DateTime from) {
    return relevantTime(DateTime.now().difference(from));
  }

  Map<String, dynamic> relevantTime(Duration duration) {
    int seconds = duration.inSeconds;
    int durationInt;
    String unit;

    if (seconds < 60) {
      durationInt = duration.inSeconds;
      unit = "seconds";
    } else if (seconds < 60 * 60) {
      durationInt = duration.inMinutes;
      unit = "minutes";
    } else if (seconds < 60 * 60 * 24) {
      durationInt = duration.inHours;
      unit = "hours";
    } else {
      durationInt = duration.inDays;
      unit = "days";
    }

    return {"durationInt": durationInt, "unit": unit};
  }