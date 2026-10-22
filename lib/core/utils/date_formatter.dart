import 'package:intl/intl.dart';

class ScheduleDateInfo {
  final String day;
  final String date;
  final int number;
  final DateTime dateTime;

  const ScheduleDateInfo({
    required this.day,
    required this.date,
    required this.number,
    required this.dateTime,
  });
}

class DateFormatter {
  DateFormatter._();

  static ScheduleDateInfo getScheduleDate(int offsetDays) {
    final now = DateTime.now();
    final targetDate = now.add(Duration(days: offsetDays));

    String dayString;
    if (offsetDays == 0) {
      dayString = 'Today';
    } else if (offsetDays == 1) {
      dayString = 'Tomorrow';
    } else {
      dayString = DateFormat('EEE').format(targetDate);
    }

    final dateString = DateFormat('MMM d').format(targetDate);
    final dayNumber = targetDate.day;

    return ScheduleDateInfo(
      day: dayString,
      date: dateString,
      number: dayNumber,
      dateTime: targetDate,
    );
  }

  static String formatHeaderDate(DateTime dateTime) {
    return DateFormat('EEEE, d MMMM').format(dateTime);
  }
}
