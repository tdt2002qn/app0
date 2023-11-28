import 'package:app0/db/db_helper.dart';

// Save user
class UserController {
  static Future<void> registerUser(String pin) async {
    await DBHelper.saveUserPin(pin);
  }

//get User
  static Future<String?> getUserPin() async {
    return await DBHelper.getUserPin();
  }
}
