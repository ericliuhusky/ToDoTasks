import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todotasks/View/TaskList.dart';

class TaskHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("待"),
      ),
      body: TaskList(),
    );
  }
}
