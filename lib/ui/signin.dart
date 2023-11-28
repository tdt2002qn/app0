// // login_screen.dart
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:app0/controllers/user_controller.dart';
// import 'package:app0/db/db_helper.dart';
// import 'package:get/get.dart';
// import 'HomePage.dart';

// class LoginScreen extends StatelessWidget {
//   final TextEditingController _pinController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             PinCodeTextField(
//               appContext: context,
//               length: 4,
//               obscureText: true,
//               animationType: AnimationType.fade,
//               pinTheme: PinTheme(
//                 shape: PinCodeFieldShape.box,
//                 borderRadius: BorderRadius.circular(5),
//                 fieldHeight: 50,
//                 fieldWidth: 40,
//                 activeFillColor: Colors.white,
//               ),
//               controller: _pinController,
//               onChanged: (value) {
//                 // Xử lý khi giá trị thay đổi (mã PIN)
//               },
//               onCompleted: (value) {
//                 // Xử lý khi đã nhập đủ độ dài mã PIN
//               },
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () async {
//                 final enteredPin = _pinController.text;
//                 final savedPin = await UserController
//                     .getUserPin(); // Gọi controller để lấy mã PIN từ cơ sở dữ liệu

//                 if (savedPin != null && savedPin == enteredPin) {
//                   // Mã PIN đúng, mở ứng dụng
//                   Get.offAll(() => HomePage()); // Điều hướng đến trang chính
//                 } else {}
//               },
//               child: Text('Đăng nhập'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
