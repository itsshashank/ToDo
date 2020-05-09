import 'package:flutter/material.dart';
import 'package:todo/ui/authenticate/register.dart';
import 'package:todo/ui/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget{
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate>{

  bool showSignIn = true;
  void toggleView(){
    setState(()=>showSignIn = !showSignIn);
  }

  Widget build(BuildContext context){
    return Container(
      child:showSignIn?SignIn(toggleView: toggleView):Register(toggleView: toggleView),
    );
  }
}