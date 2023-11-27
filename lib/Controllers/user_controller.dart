import 'package:app0/db/db_helper.dart';

class UserController {
  static Future<void> registerUser(String pin) async {
    await DBHelper.saveUserPin(pin);
  }

  static Future<String?> getUserPin() async {
    return await DBHelper.getUserPin();
  }
}
