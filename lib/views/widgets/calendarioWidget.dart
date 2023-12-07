import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatelessWidget {
  final String nivelUsuario;

  CustomCalendar({super.key, required this.nivelUsuario});

  @override
  Widget build(BuildContext context) {
    Color colorDiaActual;

    switch (nivelUsuario) {
      case 'principiante':
        colorDiaActual = Colors.green;
        break;
      case 'intermedio':
        colorDiaActual = Colors.orange;
        break;
      case 'experto':
        colorDiaActual = Colors.red;
        break;
      default:
        colorDiaActual = Colors.grey;
        break;
    }

    return TableCalendar(
  focusedDay: DateTime.now(),
  firstDay: DateTime.utc(2010, 10, 16),
  lastDay: DateTime.utc(2030, 3, 14),
  calendarFormat: CalendarFormat.week,
  availableGestures: AvailableGestures.none,
  calendarStyle: CalendarStyle(
    todayDecoration: BoxDecoration(
      color: colorDiaActual,
      shape: BoxShape.circle,
    ),
    defaultTextStyle: const TextStyle(color: Colors.white),
    weekendTextStyle: const TextStyle(color: Colors.white),
    outsideTextStyle: const TextStyle(color: Colors.white),
    holidayTextStyle: const TextStyle(color: Colors.white),
  ),
  headerStyle: const HeaderStyle(
    leftChevronVisible: false,
    rightChevronVisible: false,
    titleCentered: true,
    formatButtonVisible: false,
    headerPadding: EdgeInsets.symmetric(vertical: 16),
    titleTextStyle: TextStyle(color: Colors.white),
  ),
  daysOfWeekStyle: const DaysOfWeekStyle(
    weekdayStyle: TextStyle(color: Colors.white), // Estilo para los días entre semana
    weekendStyle: TextStyle(color: Colors.white), // Estilo para los fines de semana, si quieres un color diferente
  ),
);

  }
}
