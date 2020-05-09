import 'dart:collection';
import 'package:todo/models/task.dart';
import 'package:flutter/cupertino.dart';

class TaskNotifier with ChangeNotifier {
  List<Task> _taskList = [];
  Task _currentTask;

  UnmodifiableListView<Task> get taskList => UnmodifiableListView(_taskList);

  Task get currentTask => _currentTask;

  set taskList(List<Task> taskList){
    _taskList = taskList;
    notifyListeners();
  }

  set currentTask(Task task){
    _currentTask = task;
    notifyListeners();
  }

}