import 'package:app0/models/task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//Lơp db
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

//Tạo bảng task
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

//Tạo bảng user
  static void _createUserTable(Database db) {
    db.execute(
      "CREATE TABLE $_userTableName("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "pin TEXT NOT NULL)", // Đặt kiểu dữ liệu của cột pin là TEXT
    );
  }

//Thêm task vào db
  static Future<int> insert(Task? task) async {
    print("insert function called");
    return await _db?.insert(_tasksTableName, task!.toJson()) ?? 1;
  }

//Lấy task từ db
  static Future<List<Map<String, dynamic>>> query() async {
    print("query function called");
    return await _db!.query(_tasksTableName);
  }

//xóa task
  static delete(Task task) async {
    return await _db!
        .delete(_tasksTableName, where: 'id=?', whereArgs: [task.id]);
  }

//Update task đã hoàn thành chưa
  static update(int id) async {
    return await _db!.rawUpdate('''
    UPDATE tasks
    SET isCompleted = ?
    WHERE id =?
''', [1, id]);
  }

//Xóa user cũ và thêm user mới
  static Future<void> saveUserPin(String pin) async {
    await _db?.delete(_userTableName);
    await _db?.insert(
      _userTableName,
      {'pin': pin},
    );
    print(pin);
  }

//Lấy mã pin user
  static Future<String?> getUserPin() async {
    final List<Map<String, dynamic>> maps = await _db!.query(_userTableName);

    if (maps.isNotEmpty) {
      final get = maps.first['pin'].toString();
      print('Get $get');
      return get;
    } else {
      return null;
    }
  }
}
