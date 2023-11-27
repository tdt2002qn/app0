import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app0/services/notificaion_services.dart';

class NotifiedPage extends StatelessWidget {
  final String? lable;
  const NotifiedPage({Key? key, required this.lable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.isDarkMode
            ? Colors.grey[600]
            : const Color.fromARGB(255, 209, 194, 60),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new_outlined,
              color: Get.isDarkMode ? Colors.white : Colors.grey),
        ),
        title: Text(
          this.lable.toString().split("|")[0],
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Container(
          height: 400,
          width: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Get.isDarkMode ? Colors.white : Colors.yellow),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "",
                  style: TextStyle(
                      color: Get.isDarkMode ? Colors.black : Colors.white,
                      fontSize: 30),
                ),
                SizedBox(height: 120),
                Text(
                  this.lable.toString().split("|")[1],
                  style: TextStyle(
                      color: Get.isDarkMode ? Colors.black : Colors.white,
                      fontSize: 30),
                ),
                SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
