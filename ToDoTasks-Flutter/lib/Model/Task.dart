import 'dart:ffi';

class Task {
  String content;
  bool isDone;
  bool isStarred;
  DateTime creationTime;

  Task({this.content, this.isDone, this.isStarred, this.creationTime});
}
