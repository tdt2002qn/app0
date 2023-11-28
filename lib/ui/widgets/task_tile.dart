import 'package:app0/models/task.dart';
import 'package:app0/ui/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TaskTile extends StatelessWidget {
  final Task? task;
  TaskTile(this.task);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 12),
      child: Container(
        padding: EdgeInsets.all(16),
        //  width: SizeConfig.screenWidth * 0.78,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _getBGClr(task?.color ?? 0),
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task?.title ?? "",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: Colors.grey[200],
                      size: 18,
                    ),
                    SizedBox(width: 4),
                    Text(
                      _calculateUpdatedTimeRange(task!),
                      style: GoogleFonts.lato(
                        textStyle:
                            TextStyle(fontSize: 13, color: Colors.grey[100]),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  task?.note ?? "",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 15, color: Colors.grey[100]),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 60,
            width: 0.5,
            color: Colors.grey[200]!.withOpacity(0.7),
          ),
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              task!.isCompleted == 1 ? "HOÀN THÀNH" : "CHƯA XONG",
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  String _calculateUpdatedTimeRange(Task task) {
    DateTime startDateTime;

    if (task.startTime != null) {
      try {
        // Xác định định dạng thời gian thực tế của chuỗi
        String timeFormat =
            task.startTime!.contains('AM') || task.startTime!.contains('PM')
                ? "h:mm a"
                : "HH:mm";

        // Sử dụng định dạng thời gian khi chuyển đổi
        startDateTime = DateFormat(timeFormat).parse(task.startTime!);
        print('aaaaa');

        // Xử lý trường hợp remind là null
        int remindMinutes = task.remind ?? 0;

        // Cộng thêm số phút từ trường remind cho startTime
        startDateTime = startDateTime.add(Duration(minutes: remindMinutes));

        // Định dạng lại thời gian và trả về dưới dạng chuỗi
        return DateFormat("h:mm a").format(startDateTime) +
            " - ${task.endTime}";
      } catch (e) {
        // In ra thông điệp lỗi
        print('Error during time conversion: $e');
      }
    }

    // Trong trường hợp lỗi hoặc startTime là null, trả về chuỗi rỗng hoặc giá trị mặc định khác
    return "111";
  }

  _getBGClr(int no) {
    switch (no) {
      case 0:
        return bluishClr;
      case 1:
        return pinkClr;
      case 2:
        return yellowClr;
      default:
        return bluishClr;
    }
  }
}
