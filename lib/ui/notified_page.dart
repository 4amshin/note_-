import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:note_3/ui/theme.dart';

class NotifiedPage extends StatelessWidget {
  final String? label;
  Color? noteClr;
  NotifiedPage({
    Key? key,
    required this.label,
    this.noteClr,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.isDarkMode ? Colors.grey[600] : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Get.isDarkMode ? Colors.white : Colors.black,
          iconSize: 20,
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
        title: Text(
          label.toString().split('|')[0],
          style: TextStyle(
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Container(
          height: 400,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: noteClr ??
                primaryClr, //if Color is null or noteClr.isEmpty the use primaryClr
          ),
          child: Center(
            child: Text(
              label.toString().split('|')[1],
              style: TextStyle(
                color: Get.isDarkMode ? Colors.black : Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
