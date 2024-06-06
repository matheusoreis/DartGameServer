class TimeUtils {
  static int milliseconds(int milliseconds) => milliseconds;
  static int seconds(int seconds) => seconds * 1000;
  static int minutes(int minutes) => seconds(minutes * 60);
  static int hours(int hours) => minutes(hours * 60);
}
