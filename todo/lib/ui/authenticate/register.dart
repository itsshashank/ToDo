import 'package:flutter/material.dart';
import 'package:todo/service/auth.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register>{

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // text fiel state
  String email = "";
  String password = "";
  String error ="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor : Colors.grey,
        elevation: 10,
        actions: <Widget>[
          FlatButton.icon(
            onPressed: (){
              widget.toggleView();
            },
            icon: Icon(Icons.backspace), 
            label: Text('Back'))
        ],
        title: Text('Sign up'),
      ),
      resizeToAvoidBottomPadding: false,
      body: Container(
        padding: EdgeInsets.symmetric(vertical:40,horizontal:50),
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
                decoration: InputDecoration(hintText: 'Password'),
                obscureText: true,
                validator: (val) => val.length<8 ? 'Enter a password atleast 8 char long' : null,
                onChanged: (value) {
                  setState(()=>password=value);
                }
              ),
              SizedBox(height: 40),
              RaisedButton(
                color: Colors.blueAccent,
                child: Text('Register',style: TextStyle(color: Colors.white),),
                onPressed: () async {
                  if(_formKey.currentState.validate()){
                    print(email);
                    
                    dynamic result = await _auth.registerWithEmail(email, password);
                    if (result == null){
                      setState(() {
                        error= "User alrady Registerd";  
                        // 'please enter valid email';
                      });
                    }
                  }
                }
              ),
              SizedBox(height: 12),
              Text(error,style: TextStyle(color: Colors.red,fontSize: 14),)
            ],),),
        ),
      );
  }
}