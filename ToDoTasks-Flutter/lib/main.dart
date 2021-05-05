import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todotasks/View/TaskHome.dart';

void main() {
  runApp(ToDoTasksApp());
}

class ToDoTasksApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "",
      home: TaskHome(),
    );
  }
}
