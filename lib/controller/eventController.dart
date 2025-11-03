import 'package:farmacio_app/helper/databaseHelper.dart';
import 'package:farmacio_app/models/eventModel.dart';

class EventController {
  Future<int> addEvent(Event event) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('events', event.toMap());
  }

  Future<int> updateEvent(Event event) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<int> deleteEvent(int id) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete('events', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Event>> getEventsByDate(DateTime date, int userId) async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'events',
      where: 'date = ? AND userId = ?',
      whereArgs: [date.toIso8601String(), userId],
    );
    return List.generate(maps.length, (i) => Event.fromMap(maps[i]));
  }
}
