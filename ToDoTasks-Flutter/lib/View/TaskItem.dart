import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todotasks/Model/Task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  TaskItem({this.task});

  @override
  Widget build(BuildContext context) {
    return SwipeDelete(
        child: Row(
      children: [
        Expanded(flex: 1, child: CheckBox(task.isDone)),
        Expanded(flex: 8, child: TaskContent(task.content, task.isDone)),
        Expanded(flex: 1, child: Star())
      ],
    ));
  }
}

class CheckBox extends StatefulWidget {
  final bool isDone;
  CheckBox(this.isDone);

  @override
  _CheckBox createState() => _CheckBox(isDone);
}

class _CheckBox extends State<CheckBox> {
  bool isDone;
  _CheckBox(this.isDone);

  void _toggle() {
    setState(() {
      if (isDone) {
        isDone = false;
      } else {
        isDone = true;
      }
    });

    HapticFeedback.vibrate();
  }

  @override
  Widget build(BuildContext context) {
    var checkmark = Icon(CupertinoIcons.check_mark);
    var circle = Icon(CupertinoIcons.circle);
    return IconButton(icon: isDone ? checkmark : circle, onPressed: _toggle);
  }
}

class TaskContent extends StatelessWidget {
  final String text;
  final bool isDone;
  TaskContent(this.text, this.isDone);

  @override
  Widget build(BuildContext context) {
    if (!isDone) {
      return TextField(onChanged: (value) {});
    }
    return Text(
      text,
      style:
          TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough),
    );
  }
}

class Star extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(
      CupertinoIcons.star_fill,
      color: Colors.yellow,
    );
  }
}

class SwipeDelete extends StatelessWidget {
  final Widget child;
  SwipeDelete({this.child});

  @override
  Widget build(BuildContext build) {
    return Dismissible(
      key: Key(""),
      child: child,
      background: Container(
        child: Align(
          alignment: Alignment.centerRight,
          child: Icon(
            CupertinoIcons.star_fill,
            color: Colors.white,
          ),
        ),
        color: Colors.yellow,
      ),
      secondaryBackground: Container(
        child: Align(
          alignment: Alignment.centerRight,
          child: Icon(
            CupertinoIcons.trash_slash,
            color: Colors.white,
          ),
        ),
        color: Colors.red,
      ),
      onDismissed: (direction) {},
    );
  }
}
