import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:note_3/controller/task_controller.dart';
import 'package:note_3/models/task.dart';
import 'package:note_3/services/notification_service.dart';
import 'package:note_3/services/theme_service.dart';
import 'package:note_3/ui/add_task.dart';
import 'package:note_3/ui/theme.dart';
import 'package:note_3/widget/button.dart';
import 'dart:developer' as devtools show log;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:note_3/widget/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  var notifyHelper = NotifyHelper();
  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.backgroundColor,
      body: Column(
        children: [
          const SizedBox(height: 10),
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(height: 10),
          _showTasks(),
        ],
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(
        () {
          return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              devtools.log('Length: ${_taskController.taskList.length}');
              Task task = _taskController.taskList[index];
              if (task.repeat == 'Daily') {
                DateTime date =
                    DateFormat.Hm().parse(task.startTime.toString());
                var myTime = DateFormat('HH:mm').format(date);
                devtools.log(myTime.toString());
                notifyHelper.scheduledNotification(
                  int.parse(myTime.toString().split(':')[0]),
                  int.parse(myTime.toString().split(':')[1]),
                  task,
                );
                return _animationConfiguration(index, task);
              }
              if (task.date == DateFormat.yMd().format(selectedDate)) {
                return _animationConfiguration(index, task);
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }

  _animationConfiguration(index, Task task) {
    return AnimationConfiguration.staggeredList(
      position: index,
      child: SlideAnimation(
        child: FadeInAnimation(
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  _showBottomSheet(
                    context,
                    task,
                  );
                },
                child: TaskTile(
                  task,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),
            const Spacer(),
            task.isCompleted == 1
                ? const SizedBox()
                : _bottomSheetButton(
                    label: "Task Completed",
                    onTap: () {
                      _taskController.markTaskCompleted(task.id!);
                      Get.back();
                    },
                    color: primaryClr,
                    context: context,
                  ),
            _bottomSheetButton(
              label: "Delete Task",
              onTap: () {
                _taskController.delete(task);
                Get.back();
              },
              color: Colors.red[300]!,
              context: context,
            ),
            const SizedBox(height: 15),
            _bottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              color: Colors.white,
              isClose: true,
              context: context,
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color color,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 45,
        width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose == true
                ? Get.isDarkMode
                    ? Colors.grey[300]!
                    : Colors.grey[600]!
                : color,
          ),
          borderRadius: BorderRadius.circular(15),
          color: isClose == true ? Colors.transparent : color,
        ),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  timeTextStyle({final double? fontSize}) {
    return GoogleFonts.lato(
      textStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(left: 15, top: 15),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: timeTextStyle(fontSize: 16),
        monthTextStyle: timeTextStyle(fontSize: 14),
        dayTextStyle: timeTextStyle(fontSize: 11),
        onDateChange: (date) {
          setState(() {
            selectedDate = date;
          });
        },
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                "Today",
                style: headingStyle,
              ),
            ],
          ),
          MyButton(
            label: "+ Add Task",
            onTap: () async {
              await Get.to(() => const AddTaskPage());
              _taskController.getTasks();
            },
          ),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
            title: 'Theme Changed',
            body: Get.isDarkMode ? 'Dark Mode Off' : 'Dark Mode On',
          );
          // notifyHelper.scheduledNotification();
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_outlined,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: const [
        CircleAvatar(
          radius: 18,
          backgroundImage: AssetImage(
            "assets/images/profile_3.jpg",
          ),
        ),
        SizedBox(width: 20),
      ],
    );
  }
}
