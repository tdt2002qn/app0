import 'package:app0/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MyButton extends StatelessWidget {
  final String lable;
  final Function()? onTap;
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
            lable,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
