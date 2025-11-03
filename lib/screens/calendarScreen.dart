import 'package:farmacio_app/controller/eventController.dart';
import 'package:farmacio_app/models/eventModel.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  Future<void> _loadEvents() async {
    final userId = await _getUserId();
    if (userId != null && _selectedDay != null) {
      events = await EventController().getEventsByDate(_selectedDay!, userId);
      setState(() {});
    }
  }

  void _showEventDialog({Event? event}) {
    final titleController = TextEditingController(text: event?.title ?? '');
    final descriptionController =
        TextEditingController(text: event?.description ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event == null ? 'Adicionar Evento' : 'Editar Evento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
          ],
        ),
        actions: [
          if (event != null)
            TextButton(
              onPressed: () async {
                await EventController().deleteEvent(event.id!);
                Navigator.pop(context);
                _loadEvents();
              },
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
            ),
          TextButton(
            onPressed: () async {
              final userId = await _getUserId();
              if (userId != null) {
                final newEvent = Event(
                  id: event?.id,
                  title: titleController.text,
                  description: descriptionController.text,
                  date: _selectedDay!,
                  userId: userId,
                );

                if (event == null) {
                  await EventController().addEvent(newEvent);
                } else {
                  await EventController().updateEvent(newEvent);
                }

                Navigator.pop(context);
                _loadEvents();
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendário')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TableCalendar(
          focusedDay: _focusedDay,
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          calendarFormat: CalendarFormat.month,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            _showEventDialog();
          },
          calendarStyle: const CalendarStyle(
            todayDecoration:
                BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
            selectedDecoration:
                BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}
