import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';

final kFirstDay = DateTime(2020, 1, 1);
final kLastDay = DateTime(2030, 12, 31);

final calendarStyle = CalendarStyle(
  outsideDaysVisible: false,
  todayDecoration: BoxDecoration(
    color: Colors.blueAccent,
    shape: BoxShape.circle,
  ),
  selectedDecoration: BoxDecoration(
    color: Colors.orangeAccent,
    shape: BoxShape.circle,
  ),
  weekendTextStyle: const TextStyle(color: Colors.red),
);

final headerStyle = HeaderStyle(
  formatButtonVisible: false,
  titleCentered: true,
);
