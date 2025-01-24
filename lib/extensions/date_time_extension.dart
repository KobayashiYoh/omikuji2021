extension DateTimeExtension on DateTime {
  bool get isNewYear => month == 1 && day <= 14;
}
