import 'package:app0/Controllers/task_controllers.dart';
import 'package:app0/models/task.dart';
import 'package:app0/ui/theme.dart';
import 'package:app0/ui/widgets/button.dart';
import 'package:app0/ui/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController =
      Get.put(TaskController()); // Khởi tạo controller cho công việc
  final _titleController =
      TextEditingController(); // Controllers cho tiêu đề  ghi chú công việc
  final _noteController = TextEditingController(); //ghi chú công việc
  DateTime _selectedDate =
      DateTime.now(); // Ngày và giờ bắt đầu/kết thúc mặc định
  String _endTime = "9:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 0;
  List<int> remindList = [
    0,
  ];

  String _selectedRepeat = "Không";
  List<String> RepeadList = [
    "Hằng ngày",
    "Hằng tuần",
    "Hằng tháng",
    "Không",
  ];

  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.dialogBackgroundColor,
      appBar: _appBar(context),
      body: Container(
          padding: EdgeInsets.only(left: 22, right: 22),
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Thêm công việc mới", style: headingStyle),
              // Ô nhập ghi chú công việc
              MyInputField(
                title: "Công việc",
                hint: "Nhập vào đây ",
                controller: _titleController,
              ),

              MyInputField(
                title: "Ghi chú",
                hint: "Nhập vào đây ",
                controller: _noteController,
              ),
              // Ô chọn ngày
              MyInputField(
                title: "Ngày",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                    icon: Icon(Icons.calendar_today_outlined,
                        color: Colors.grey[500]),
                    onPressed: () {
                      _getDateFromUser();
                    }),
              ),
              // Ô nhập giờ bắt đầu và kết thúc
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                      title: "Bắt đầu",
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                        icon: Icon(
                            Get.isDarkMode
                                ? Icons.access_time_rounded
                                : Icons.access_time_filled_outlined,
                            color:
                                Get.isDarkMode ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: MyInputField(
                      title: "Kết thúc",
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                        icon: Icon(
                            Get.isDarkMode
                                ? Icons.access_time_rounded
                                : Icons.access_time_filled_outlined,
                            color:
                                Get.isDarkMode ? Colors.white : Colors.black),
                      ),
                    ),
                  )
                ],
              ),
              // Ô chọn nhắc nhở
              MyInputField(
                title: "Nhắc nhở",
                hint: " sớm hơn $_selectedRemind phút",
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down,
                      color: Get.isDarkMode ? Colors.white : Colors.black),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(
                    height: 0,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRemind = int.parse(newValue!);
                    });
                  },
                  items: remindList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
              ),

              // Ô chọn lặp lại
              MyInputField(
                title: "Lặp lại",
                hint: "$_selectedRepeat ",
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down,
                      color: Get.isDarkMode ? Colors.white : Colors.black),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(
                    height: 0,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                  items:
                      RepeadList.map<DropdownMenuItem<String>>((String? value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value!,
                        style: TextStyle(
                            color:
                                Get.isDarkMode ? Colors.white : Colors.black),
                      ),
                    );
                  }).toList(),
                ),
              ),
              // Khoảng cách giữa các ô nhập và nút
              SizedBox(
                height: 18,
              ),
              // Hàng chứa ô chọn màu sắc và nút "Xong"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPallete(),
                  MyButton(lable: "Xong", onTap: () => _validateDate())
                ],
              )
            ],
          ))),
    );
  }

  // Phần App Bar
  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.dialogBackgroundColor,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios_new_sharp,
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

  // Hàm kiểm tra và lưu công việc vào cơ sở dữ liệu
  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      //add to database
      _addTaskToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar("Yêu cầu!!!", "Vui lòng nhập đầy đủ !",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.red,
          icon: Icon(Icons.warning_amber_rounded));
    }
  }

  // Hàm thêm công việc vào cơ sở dữ liệu
  _addTaskToDb() async {
    int value = await _taskController.addTask(
        task: Task(
      note: _noteController.text,
      title: _titleController.text,
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      remind: _selectedRemind,
      repeat: _selectedRepeat,
      color: _selectedColor,
      isCompleted: 0,
    ));
    print("My id: " + "$value");
  }

  // Hàm hiển thị bảng màu sắc cho công việc
  _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Màu sắc",
          style: titleStyle,
        ),
        SizedBox(
          height: 8.0,
        ),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                  print("$index");
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, bottom: 20),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? browmClr
                          : yellowClr,
                  child: _selectedColor == index
                      ? Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 16,
                        )
                      : Container(),
                ),
              ),
            );
          }),
        )
      ],
    );
  }

  // Hàm lấy ngày từ người dùng
  _getDateFromUser() async {
    DateTime? _pickedate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2125),
    );

    if (_pickedate != null) {
      setState(() {
        _selectedDate = _pickedate;
        print(_selectedDate);
      });
    } else {
      print("O trong hoac bi loi");
    }
  }

// Hàm lấy thời gian từ người dùng
  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print("Time cancel");
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  // Hàm hiển thị bảng chọn thời gian
  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
    );
  }
}
