import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:app0/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'HomePage.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _pinController = TextEditingController();
  int _pinAttempts = 0;
  String _enteredPin = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng ký mã PIN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PinCodeTextField(
              appContext: context,
              length: 4,
              obscureText: true,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                activeFillColor: Colors.white,
              ),
              controller: _pinController,
              onChanged: (value) {
                // Xử lý khi giá trị thay đổi (mã PIN)
              },
              onCompleted: (value) {
                // Xử lý khi đã nhập đủ độ dài mã PIN
                _handlePinCompleted(value);
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final pin = _pinController.text;
                if (_pinAttempts == 0) {
                  // Lần nhập thứ nhất
                  _enteredPin = pin;
                  _pinAttempts++;
                  _pinController.clear();
                  // Hiển thị thông báo hoặc cập nhật UI để thông báo người dùng
                  // rằng họ cần nhập mã PIN lần nữa
                  _showSnackBar('Nhập lại mã PIN để xác nhận');
                } else if (_pinAttempts == 1 && pin == _enteredPin) {
                  // Lần nhập thứ hai và trùng khớp
                  await UserController.registerUser(pin);
                  Get.offAll(() => HomePage());
                } else {
                  // Lần nhập thứ hai nhưng không trùng khớp
                  _pinAttempts = 0;
                  _enteredPin = '';
                  _pinController.clear();
                  // Hiển thị thông báo hoặc cập nhật UI để thông báo người dùng
                  // rằng mã PIN không trùng khớp và họ cần nhập lại từ đầu
                  _showSnackBar(
                      'Mã PIN không trùng khớp. Vui lòng nhập lại từ đầu.');
                }
              },
              child: Text('Tạo mã PIN'),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePinCompleted(String value) {
    // Xử lý khi đã nhập đủ độ dài mã PIN
    // (Nếu bạn muốn thực hiện xử lý nào đó khi người dùng đã nhập xong)
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ));
  }
}
