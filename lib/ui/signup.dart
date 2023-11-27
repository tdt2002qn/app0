// register_screen.dart
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:app0/controllers/user_controller.dart';
import 'package:app0/db/db_helper.dart';
import 'package:get/get.dart';
import 'HomePage.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final pin = _pinController.text;
                if (pin.isNotEmpty) {
                  await UserController.registerUser(
                      pin); // Gọi controller để lưu mã PIN
                  Get.offAll(() => HomePage()); // Quay lại trang đăng nhập
                } else {
                  // Hiển thị thông báo lỗi
                }
              },
              child: Text('Tạo mã PIN'),
            ),
          ],
        ),
      ),
    );
  }
}
