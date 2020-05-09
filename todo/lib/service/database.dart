import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/models/task.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference taskCollection =
      Firestore.instance.collection('Tasks');

  Future uploadTask(Task task) async {
    return await taskCollection.add(task.toMap());
  }
  updateTaskStatus(Task task) async {
    await taskCollection.document(task.id).setData(task.toMap());
  }
}
