import '../theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class MyInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  
  
  MyInputField({super.key, required this.title, required this.hint, this.controller, this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:titleStyle,
            ),
            Container(
              height: 50,
              margin: EdgeInsets.only(top: 8.0),
              padding: EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blueGrey,
                  width: 1.0
                ),
                borderRadius: BorderRadius.circular(12)
              ),
              child: Row(
                children: [
                  Expanded(child: TextFormField(
                    readOnly: widget==null?false:true,
                    autofocus: false,
                    cursorColor: Get.isDarkMode?Colors.red[100]:Colors.red[700],
                    controller: controller,
                    style: subTitleStyle,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: subTitleStyle,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.colorScheme.background,
                          width: 0
                        )
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.colorScheme.background,
                          width: 0
                        )
                      ),
                    ),
                  )
                  ),
                  widget==null?Container():Container(child: widget)
                ],
              ),
            ),


        ],)
    );
  }
}