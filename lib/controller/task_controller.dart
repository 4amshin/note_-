import 'package:get/get.dart';
import 'package:note_3/db/db_helper.dart';
import 'package:note_3/models/task.dart';
import 'dart:developer' as devtools show log;

class TaskController extends GetxController {
  @override
  void onReady() {
    getTasks();
    super.onReady();
  }

  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  void delete(Task task) {
    DBHelper.delete(task);
    getTasks();
    devtools.log('Delete function called');
  }

  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
    devtools.log('Update function called');
  }
}
