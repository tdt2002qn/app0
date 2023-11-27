import 'package:app0/models/task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _tasksTableName = "tasks";
  static final String _userTableName = "user";

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = join(await getDatabasesPath(), 'tasks.db');
      ;

      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) {
          _createTasksTable(db);
          _createUserTable(db);
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static void _createTasksTable(Database db) {
    db.execute(
      "CREATE TABLE $_tasksTableName("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "title STRING, note TEXT, date STRING, "
      "startTime STRING, endTime STRING, "
      "remind INTEGER, repeat STRING, "
      "color INTEGER, "
      "isCompleted INTEGER)",
    );
  }

  static void _createUserTable(Database db) {
    db.execute(
      "CREATE TABLE $_userTableName("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "pin STRING)",
    );
  }

  static Future<int> insert(Task? task) async {
    print("insert function called");
    return await _db?.insert(_tasksTableName, task!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("query function called");
    return await _db!.query(_tasksTableName);
  }

  static delete(Task task) async {
    return await _db!
        .delete(_tasksTableName, where: 'id=?', whereArgs: [task.id]);
  }

  static update(int id) async {
    return await _db!.rawUpdate('''
    UPDATE tasks
    SET isCompleted = ?
    WHERE id =?
''', [1, id]);
  }

  //User
  // lib/db/db_helper.dart
// Thêm phương thức sau vào DBHelper để lưu mã PIN mới vào cơ sở dữ liệu
  static Future<void> saveUserPin(String pin) async {
    await _db?.delete(_userTableName); // Xóa bản ghi người dùng hiện tại
    await _db?.insert(
        _userTableName, {'pin': pin}); // Thêm bản ghi mới với mã PIN mới
    print(pin);
  }

  // lib/db/db_helper.dart
// Thêm phương thức sau vào DBHelper để lấy mã PIN từ cơ sở dữ liệu
  static Future<String?> getUserPin() async {
    final List<Map<String, dynamic>> maps = await _db!.query(_userTableName);

    if (maps.isNotEmpty) {
      return maps.first['pin'].toString();
    } else {
      return null;
    }
  }
}
