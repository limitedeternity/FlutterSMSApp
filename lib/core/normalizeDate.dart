String normalizeDate(DateTime date) {
  String twoDigits(int number) {
    int absNumber = number.abs();
    String sign = number < 0 ? "-" : "";

    if (absNumber >= 10) return "$sign$absNumber";
    return "${sign}0$absNumber";
  }

  String timeHour = twoDigits(date.hour);
  String timeMinute = twoDigits(date.minute);
  String timeSecond = twoDigits(date.second);

  String dateDay = twoDigits(date.day);
  String dateMonth = twoDigits(date.month);
  String dateYear = date.year.toString();

  return "$timeHour:$timeMinute:$timeSecond $dateDay.$dateMonth.$dateYear";
}
