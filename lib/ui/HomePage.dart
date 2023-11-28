import 'dart:io';

import 'package:app0/models/task.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:app0/Controllers/user_controller.dart';
import 'package:app0/Controllers/task_controllers.dart';
import 'package:app0/services/notificaion_services.dart';
import 'package:app0/services/theme_services.dart';
import 'package:app0/ui/add_task_bar.dart';
import 'package:app0/ui/theme.dart';
import 'package:app0/ui/widgets/button.dart';
import 'package:app0/ui/widgets/task_tile.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:app0/ui/signin.dart';
import 'package:app0/ui/signup.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  var notifyHelper;
  String? userPin;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    _checkUserPin();
  }

  _checkUserPin() async {
    userPin = await UserController.getUserPin();
    if (userPin == null) {
      // Mã PIN chưa được đặt, chuyển đến trang đăng ký(chưa fix được lỗi)
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => RegisterScreen()));
    } else {
      _requestPin();
    }
  }

  _requestPin() {
    // Hiển thị màn hình nhập mã PIN ở đây
    // showDialog để nhập mã PIN
    showDialog(
      context: context,
      barrierDismissible:
          false, // Ngăn chặn việc đóng hộp thoại khi chạm ra ngoài
      builder: (context) => Stack(
        children: [
          // Màn hình chính của ứng dụng (phía sau hộp thoại)
          Scaffold(
            appBar: AppBar(
              title:
                  Text('Màn hình chính'), // Thêm tiêu đề hoặc nội dung phù hợp
            ),
            body: Container(
                // Đặt nội dung chính của ứng dụng ở đây
                ),
          ),
          // Hộp thoại nhập mã PIN
          Center(
            child: AlertDialog(
              backgroundColor: Colors.transparent, // Đặt màu nền trong suốt
              content: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: Center(
                  child: PinCodeTextField(
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
                    onChanged: (value) {
                      // Xử lý khi giá trị thay đổi (mã PIN)
                    },
                    onCompleted: (value) {
                      // Xử lý khi đã nhập đủ độ dài mã PIN
                      if (value == userPin) {
                        Navigator.pop(context); // Đóng hộp thoại
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Mã PIN Sai'),
                            content: Text('Vui lòng kiểm tra lại mã PIN.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Đóng hộp thoại
                                  // Thoát ứng dụng
                                  Navigator.of(context)
                                      .popUntil((route) => exit(0));
                                },
                                child: Text('Thoát'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.colorScheme.background,
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          SizedBox(
            height: 12,
          ),
          _showTasks(),
        ],
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              Task task = _taskController.taskList[index];
              print(task.toJson());
              // Kiểm tra và lập lịch thông báo
              if (task.repeat == 'Hằng ngày') {
                DateTime date =
                    DateFormat.Hm().parse(task.startTime.toString());
                var myTime = DateFormat("HH:mm").format(date);
                notifyHelper.scheduledNotification(
                    int.parse(myTime.toString().split(":")[0]),
                    int.parse(myTime.toString().split(":")[1]),
                    task);

                // Sử dụng các hiệu ứng khi hiển thị danh sách công việc
                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                          child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(context, task);
                            },
                            child: TaskTile(task),
                          )
                        ],
                      )),
                    ));
              }

              // Hiển thị công việc theo ngày được chọn

              if (task.date == DateFormat.yMd().format(_selectedDate)) {
                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                          child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(context, task);
                            },
                            child: TaskTile(task),
                          )
                        ],
                      )),
                    ));
              } else {
                return Container();
              }
            });
      }),
    );
  }

//để hiển thị bottom sheet khi người dùng chạm vào một công việc.
  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.24
            : MediaQuery.of(context).size.height * 0.32,
        color: Get.isDarkMode ? darkGreyClr : Colors.white,
        child: Column(
          children: [
            Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:
                        Get.isDarkMode ? Colors.grey[600] : Colors.grey[300])),
            Spacer(),
            task.isCompleted == 1
                ? Container()
                : _bottomSheetButton(
                    lable: "Hoàn thành công việc",
                    onTap: () {
                      _taskController.markTaskCompleted(task.id!);
                      Get.back();
                    },
                    clr: primaryClr,
                    context: context,
                  ),
            _bottomSheetButton(
              lable: "Xóa công việc",
              onTap: () {
                _taskController.delete(task);

                Get.back();
              },
              clr: Colors.red[300]!,
              context: context,
            ),
            SizedBox(
              height: 20,
            ),
            _bottomSheetButton(
              lable: "Đóng",
              onTap: () {
                Get.back();
              },
              clr: Colors.white,
              isClose: true,
              context: context,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

//để tạo và trả về widget của các nút trong bottom sheet.
  _bottomSheetButton({
    required String lable,
    required Function()? onTap,
    required Color clr,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          height: 55,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            border: Border.all(
                width: 2,
                color: isClose == true
                    ? Get.isDarkMode
                        ? Colors.grey[600]!
                        : Colors.grey[300]!
                    : clr),
            borderRadius: BorderRadius.circular(20),
            color: isClose == true ? Colors.transparent : clr,
          ),
          child: Center(
            child: Text(
              lable,
              style: isClose
                  ? titleStyle
                  : titleStyle.copyWith(color: Colors.white),
            ),
          ),
        ));
  }

// Phương thức để hiển thị thanh chọn ngày.
  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 18, left: 18),
      child: DatePicker(DateTime.now(),
          height: 100,
          width: 80,
          initialSelectedDate: DateTime.now(),
          selectionColor: primaryClr,
          selectedTextColor: Colors.white,
          dateTextStyle: GoogleFonts.lato(
              textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey)),
          monthTextStyle: GoogleFonts.lato(
              textStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey)), onDateChange: (date) {
        setState(() {
          _selectedDate = date;
        });
      }),
    );
  }

//Phương thức để hiển thị thanh tiêu đề và nút thêm công việc
  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                'Hôm nay',
                style: headingStyle,
              )
            ]),
          ),
          MyButton(
              lable: 'Thêm',
              onTap: () async {
                await Get.to(() => AddTaskPage());
                _taskController.getTasks();
              }),
        ],
      ),
    );
  }

//Phương thức để tạo thanh ứng dụng.
  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.dialogBackgroundColor,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
              title: "Thay đổi chế độ giao diện",
              body: Get.isDarkMode ? "Chế độ tối" : "Chế độ sáng");
          //notifyHelper.scheduledNotification();
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_sharp : Icons.nightlight_sharp,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage("images/profile.jpg"),
        ),
        SizedBox(
          width: 17,
        ),
      ],
    );
  }
}
