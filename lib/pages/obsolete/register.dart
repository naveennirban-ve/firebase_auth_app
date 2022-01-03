import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/controllers/validators.dart';
import 'package:firebase_auth_app/pages/obsolete/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../dashboard.dart';

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
  String _responseMessage = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;


  /// Initialize Firebase Instance(App)
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }



  /// Dispose controllers
  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  /// Anonymously Login
  Future<User?> signInAnonymously() async{
    final User? user = (await _auth.signInAnonymously()).user;
    if(user != null){
      setState(() {
        _responseMessage = "success";
      });
    }else{
      setState(() {
        _responseMessage = "success";
      });
    }
    return user;
  }

  /// Firebase Email Password Register
  _register() async {
    try{
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
    }}
    on FirebaseAuthException catch (e) {
      print(e.code);
      setState(() {
        _responseMessage = e.code;
      });

    }
    //return _responseMessage;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 16),
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
                            if(_success){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Dashboard()),
                              );
                            }else{
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(_responseMessage),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        child: Text('Ok'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
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
                        const SizedBox(height: 20,),
                        Row(children: [
                          const Text("Already a user"),
                          InkWell(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const Login()),
                              );
                            },
                            child: const Text("Login here",style: TextStyle(fontSize: 18,color: Colors.blue),),
                          )
                        ],),
                        Container(
                          padding: const EdgeInsets.only(top: 16.0),
                          alignment: Alignment.center,
                          child: ElevatedButton(
                              onPressed: () async {
                                User? user =  await signInAnonymously();
                                if(_responseMessage=="success"){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const Dashboard()),
                                  );
                                }
                              },
                              child: Text("Anon Sign in")),
                        ),


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

