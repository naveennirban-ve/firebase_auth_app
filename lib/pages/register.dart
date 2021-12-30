import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/controlllers/validators.dart';
import 'package:firebase_auth_app/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextController =  TextEditingController();
  final _passwordTextController =  TextEditingController();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  bool _success = false;
  String _userEmail = "";

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }
  void _register() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = (await
    _auth.createUserWithEmailAndPassword(
      email: _emailTextController.text,
      password: _passwordTextController.text,
    )
    ).user;
    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email!;
      });
    } else {
      setState(() {
        _success = true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16,horizontal: 16),
        child: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _emailTextController,
                          focusNode: _focusEmail,
                          decoration: const InputDecoration(
                            hintText: "Email",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                            ),
                          ),

                          validator: (value) => Validator.validateEmail(email: value.toString()),
                        ),
                        const SizedBox(height: 8.0),
                        TextFormField(
                          controller: _passwordTextController,
                          focusNode: _focusPassword,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: "Password",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                            ),
                          ),
                          validator: (value) => Validator.validatePassword(password: value.toString()),
                        ),
                        ElevatedButton(onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _register();
                          }
                        }, child: const Text("Submit")),
                        Container(
                          alignment: Alignment.center,
                          child: Text(_success == null
                              ? ''
                              : (_success
                              ? 'Successfully registered ' + _userEmail
                              : 'Registration failed')),
                        ),
                        SizedBox(height: 20,),
                        Row(children: [
                          Text("Already a user"),
                          InkWell(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Home()),
                              );
                            },
                            child: Text("Login here",style: TextStyle(fontSize: 18,color: Colors.blue),),
                          )
                        ],)


                      ],
                    ),
                  )
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

