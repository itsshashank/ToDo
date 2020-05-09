import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'service/taskNotifier.dart';
import 'service/auth.dart';
import 'models/user.dart';
import 'ui/authenticate/authenticate.dart';
import 'ui/home.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (BuildContext context) =>TaskNotifier())
    ],
    child:MyApp()
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        dialogBackgroundColor: Colors.transparent
      ),
      home: Start()
    );
  }
}

class Start extends StatelessWidget{
  Widget build(BuildContext context){
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: Wrapper(),
    );
  }
}

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
