import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String title;
  String note;
  String completed;
  String deadline;
  String uid;

  Task(
      {
      this.completed,
      this.title,
      this.note,
      this.uid
      });

  Task.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    note = data['note'];
    completed = data['completed'];
    deadline = data['deadline'];
    uid = data['uid'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid':uid,
      'title': title,
      'note': note,
      'completed': completed,
      'deadine': deadline
    };
  }
}
