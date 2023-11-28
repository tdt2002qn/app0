import 'package:app0/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MyButton extends StatelessWidget {
  final String lable; // Text hiển thị trên nút
  final Function()? onTap; // Hàm được gọi khi nút được nhấp

  // Constructor nhận vào một chuỗi làm nội dung cho nút và một hàm để xử lý sự kiện nhấp
  const MyButton({Key? key, required this.lable, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: primaryClr),
        child: Center(
          child: Text(
            lable, // Hiển thị nội dung của nút
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
