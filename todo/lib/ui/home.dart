import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/task.dart';
import 'package:todo/models/user.dart';
import 'package:todo/service/database.dart';
import 'package:todo/service/taskNotifier.dart';
import 'package:velocity_x/velocity_x.dart';

User user;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool show = true;
  void toggleView() {
    setState(() => show = !show);
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    print(user.uid);
    return Scaffold(
      body: Container(
        child: show
            ? ViewList(toggleView: toggleView)
            : ViewCompList(toggleView: toggleView),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => AddTask()));
          }),
    );
  }
}

class ViewList extends StatefulWidget {
  final Function toggleView;
  ViewList({this.toggleView});
  @override
  _ViewListState createState() => _ViewListState();
}

class _ViewListState extends State<ViewList> {
  getTask(TaskNotifier taskNotifier) async {
    QuerySnapshot snapshot =
        await Firestore.instance.collection("Tasks").getDocuments();
    List<Task> _taskList = [];
    snapshot.documents.forEach((document) {
      Task task = Task.fromMap(document.data);
      _taskList.add(task);
    });
    taskNotifier.taskList = _taskList;
  }

  @override
  void initState() {
    TaskNotifier taskNotifier =
        Provider.of<TaskNotifier>(this.context, listen: false);
    getTask(taskNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TaskNotifier taskNotifier = Provider.of<TaskNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text("T o D o"),
        elevation: 0,
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                widget.toggleView();
              },
              icon: Icon(Icons.check),
              label: Text('Completed\nTasks'))
        ],
      ),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            if (taskNotifier.taskList[index].completed != "No"&&taskNotifier.taskList[index].uid==user.uid)
              return Text('');
            return ListTile(
              title: Text(taskNotifier.taskList[index].title),
              // subtitle: Text(taskNotifier.requestList[index].note),
              onTap: () {
                taskNotifier.currentTask = taskNotifier.taskList[index];
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return ShowTask();
                }));
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            if (taskNotifier.taskList[index].completed != "No"&&taskNotifier.taskList[index].uid==user.uid)
              return Text('');
            return Divider(
              color: Colors.blueGrey,
            );
          },
          itemCount: taskNotifier.taskList.length),
    );
  }
}

class ShowTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TaskNotifier taskNotifier = Provider.of(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text(taskNotifier.currentTask.title),
        elevation: 0,
      ),
      body:  Container(
        color: VelocityX.gray200,
        child: Center(
          child: VStack(
            [
                  taskNotifier.currentTask.note
                  .text
                  .white
                  .xl2
                  .textStyle(context.textTheme.caption)
                  .center
                  .make()
                  .box
                  .width(300)
                  .height(200)
                  .p32
                  .alignCenter
                  .gray700
                  .rounded
                  .neumorphic()
                  .make(),
            ],
            alignment: MainAxisAlignment.center,
            crossAlignment: CrossAxisAlignment.center,
          ),
        ))
    );
  }
}

class ViewCompList extends StatefulWidget {
  final Function toggleView;
  ViewCompList({this.toggleView});
  @override
  _ViewCompListState createState() => _ViewCompListState();
}

class _ViewCompListState extends State<ViewCompList> {
  getTask(TaskNotifier taskNotifier) async {
    QuerySnapshot snapshot =
        await Firestore.instance.collection("Tasks").getDocuments();
    List<Task> _taskList = [];
    snapshot.documents.forEach((document) {
      Task task = Task.fromMap(document.data);
      _taskList.add(task);
    });
    taskNotifier.taskList = _taskList;
  }

  @override
  void initState() {
    TaskNotifier taskNotifier =
        Provider.of<TaskNotifier>(this.context, listen: false);
    getTask(taskNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TaskNotifier taskNotifier = Provider.of<TaskNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text("T o D o"),
        elevation: 0,
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                widget.toggleView();
              },
              icon: Icon(Icons.check_box_outline_blank),
              label: Text('Incomplete\nTasks'))
        ],
      ),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            if (taskNotifier.taskList[index].completed != "Yes"&&taskNotifier.taskList[index].uid==user.uid)
              return Text('');
            return ListTile(
              title: Text(taskNotifier.taskList[index].title),
              onTap: () {
                taskNotifier.currentTask = taskNotifier.taskList[index];
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return ShowTask();
                }));
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            if (taskNotifier.taskList[index].completed != "Yes"&&taskNotifier.taskList[index].uid==user.uid)
              return Text('');
            return Divider(
              color: Colors.blueGrey,
            );
          },
          itemCount: taskNotifier.taskList.length
        ),
    );
  }
}

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formkey = GlobalKey<FormState>();
  Task _task;

  String title;
  String note;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.grey,
          title: Text("New Task"),
          elevation: 0,
        ),
        body: Container(
          // padding: EdgeInsets.symmetric(vertical: 50,horizontal:50),
          padding: EdgeInsets.all(30),
          child: Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 50),
                Image(image: AssetImage('assets/name.png')),
                SizedBox(height: 50),
                TextFormField(
                    decoration: InputDecoration(hintText: 'Title'),
                    validator: (val) => val.isEmpty ? 'Enter an Title' : null,
                    onChanged: (val) {
                      setState(() => title = val);
                    }),
                SizedBox(height: 30),
                TextFormField(
                    decoration: InputDecoration(hintText: 'Note'),
                    onChanged: (value) {
                      setState(() => note = value);
                    }),
                SizedBox(height: 40),
                RaisedButton(
                    color: Colors.blueAccent,
                    child: Icon(Icons.check),
                    // Text('Sign in',style: TextStyle(color: Colors.white),),
                    onPressed: () async {
                      if (_formkey.currentState.validate()) {
                        _task = new Task(
                            title: title,
                            note: note,
                            completed: "No",
                            uid: user.uid);
                        DocumentReference dbref =
                            await DatabaseService(uid: user.uid)
                                .uploadTask(_task);
                        await DatabaseService(uid: user.uid)
                            .updateTaskStatus(_task);
                        _task.id = dbref.documentID;
                        await dbref.setData(_task.toMap(), merge: true);
                        Fluttertoast.showToast(
                          msg: "Task Added",
                          gravity: ToastGravity.BOTTOM,
                        );
                        Navigator.maybePop(context);
                      }
                    }),
              ],
            ),
          ),
        ));
  }
}
