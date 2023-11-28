//Tạo model User
class UserModel {
  late int id;
  late String pin;

  UserModel({required this.id, required this.pin});

  Map<String, dynamic> toMap() {
    return {'id': id, 'pin': pin};
  }
}
