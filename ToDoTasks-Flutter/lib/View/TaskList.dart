import 'package:flutter/material.dart';
import 'package:todotasks/Model/Task.dart';
import 'TaskItem.dart';

class TaskList extends StatefulWidget {
  @override
  _TaskList createState() => _TaskList();
}

class _TaskList extends State<TaskList> {
  List<Task> tasks = [
    Task(
        content: "",
        isDone: false,
        isStarred: false,
        creationTime: DateTime.now()),
    Task(
        content: "",
        isDone: false,
        isStarred: false,
        creationTime: DateTime.now()),
    Task(
        content: "",
        isDone: false,
        isStarred: false,
        creationTime: DateTime.now()),
    Task(
        content: "",
        isDone: false,
        isStarred: false,
        creationTime: DateTime.now()),
    Task(
        content: "",
        isDone: false,
        isStarred: false,
        creationTime: DateTime.now())
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: tasks.length,
        itemExtent: 60,
        itemBuilder: (context, index) {
          return TaskItem(task: tasks[index]);
        });
  }
}
