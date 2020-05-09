import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todo/service/auth.dart';

class SignIn extends StatefulWidget{

  final Function toggleView;
  SignIn({this.toggleView});

    @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn>{

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool showPassword = false;

  // text fiel state
  String email = "";
  String password = "";
  String error ="";

    void _changepwdType() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor : Colors.white10,
        elevation: 0,
      ),
      resizeToAvoidBottomPadding: false,
      body: Container(
        // padding: EdgeInsets.symmetric(vertical: 50,horizontal:50),
        padding: EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 50),
              Image(image: AssetImage('assets/name.png')),
              SizedBox(height: 50),
              TextFormField(
                decoration: InputDecoration(hintText: 'Email'),
                validator: (val) => val.isEmpty ? 'Enter an email' : null,
                onChanged: (val){
                  setState(()=>email=val);
                }
              ),
              SizedBox(height: 30),
              TextFormField(
                decoration: InputDecoration(hintText: 'Password',suffixIcon: IconButton(icon: Icon(showPassword?Icons.visibility:Icons.visibility_off),onPressed: _changepwdType,)),
                obscureText: !showPassword,
                validator: (val) => val.length<8 ? 'Enter a password atleast 8 char long' : null,
                onChanged: (value) {
                  setState(()=>password=value);
                }
              ),
              SizedBox(height: 40),
              RaisedButton(
                color: Colors.blueAccent,
                child: Text('Sign in',style: TextStyle(color: Colors.white),),
                onPressed: () async {
                  if(_formKey.currentState.validate()){
                    print(email);
                    dynamic result = await _auth.signInWithEmail(email, password);
                    if (result == null){
                      setState(() {
                        error='Wrong Username/Password';
                      });
                      // setState(()=>error='Wrong Username/Password');
                    }
                  }
                }
              ),
              SizedBox(height: 12),
              Text(error,style: TextStyle(color: Colors.red,fontSize: 20),),
              FlatButton(
              key: Key('register'),
              child: Text(
                "Need an account? Register",
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              ),
              onPressed: (){
                widget.toggleView();
              },
              ),
            ],),),
        ),
      );
  }
}