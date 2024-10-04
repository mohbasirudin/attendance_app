import 'package:attendanceapp/storage/models/attendance.dart';
import 'package:attendanceapp/storage/pref.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalStorage {
  Database? _database;
  String table = "attendance";
  Future<void> _init() async {
    final dir = await getDatabasesPath();
    final path = join(dir, '_id_beedev_basirudin_attendance.db');
    _database = await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE IF NOT EXISTS attendance ('
      'id INTEGER PRIMARY KEY, '
      'name TEXT, '
      'inTime TEXT, '
      'outTime TEXT, '
      'createdAt TEXT, '
      'updatedAt TEXT, '
      'success INTEGER)',
    );
  }

  Future<bool> insert(Attendance data) async {
    try {
      if (_database == null) await _init();
      var value = await _database!.insert(table, data.toMap());
      print("value insert $value");

      var id = await Pref().get(PrefKey.id);
      id++;
      await Pref().set(PrefKey.id, id);
      return value > -1;
    } catch (e) {
      print("value insert $e");

      return false;
    }
  }

  Future<bool> update(Attendance data) async {
    try {
      if (_database == null) await _init();
      print("data id: ${data.id}");
      var value = await _database!.update(
        table,
        data.toMap(),
        where: 'id = ?',
        whereArgs: [data.id],
      );
      print("value update $value");
      return value > -1;
    } catch (e) {
      print("value update $e");

      return false;
    }
  }

  Future<Attendance?> get(int id) async {
    try {
      if (_database == null) await _init();
      var value =
          await _database!.query(table, where: 'id = ?', whereArgs: [id]);
      return value.map((e) => Attendance.fromMap(e)).first;
    } catch (e) {
      return null;
    }
  }

  Future<List<Attendance>> all() async {
    try {
      if (_database == null) await _init();
      var value = await _database!.query(table, orderBy: 'id DESC');
      return value.map((e) => Attendance.fromMap(e)).toList();
    } catch (e) {
      return [];
    }
  }
}
