import 'package:firebase_auth_app/controllers/validators.dart';
import 'package:firebase_auth_app/pages/dashboard.dart';
import 'package:firebase_auth_app/pages/obsolete/register.dart';
import 'package:firebase_auth_app/pages/signUp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  String? _userEmail = "";
  String _responseMessage = "";

  FirebaseAuth auth = FirebaseAuth.instance;


  /// Initialize Firebase app
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  /// SignInUsingEmailPassword
  Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
       user = (await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).user;
      if (user != null) {
        setState(() {
          _userEmail = user!.email;
        });
      } else {
        setState(() {
          _responseMessage = "success";
        });
      }
    } on FirebaseAuthException catch (e) {
      _responseMessage = e.code;
    }
    return user;
  }

  /// Anonymously Login
  Future<User?> signInAnonymously() async{
    final User? user = (await auth.signInAnonymously()).user;
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

  /// Dispose Controllers
  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                              borderSide: BorderSide(
                                  color: Colors.lightBlueAccent, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.lightBlueAccent, width: 1.0),
                            ),
                          ),
                          validator: (value) =>
                              Validator.validateEmail(email: value.toString()),
                        ),
                        const SizedBox(height: 8.0),
                        TextFormField(
                          controller: _passwordTextController,
                          focusNode: _focusPassword,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: "Password",
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.lightBlueAccent, width: 1.0),
                            ),
                          ),
                          validator: (value){
                            Validator.validatePassword(password: value.toString());

                            },
                        ),
                        ElevatedButton(
                            onPressed: () async{
                              if (_formKey.currentState!.validate()) {
                                 User? user = await signInUsingEmailPassword(
                                    email: _emailTextController.text,
                                    password: _passwordTextController.text,
                                    context: context);

                                 if(user!=null){
                                   //passwordValidateMessage="";
                                   Navigator.push(
                                     context,
                                     MaterialPageRoute(builder: (context) => const Dashboard()),
                                   );
                                 }else{
                                   showDialog(
                                       context: context,
                                       builder: (BuildContext context) {
                                     return AlertDialog(
                                       title: Text(_responseMessage),
                                       actions: <Widget>[
                                         ElevatedButton(
                                           child: const Text('Ok'),
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
                            },
                            child: const Text("Submit")),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Text("New User "),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignUp()),
                                );
                              },
                              child: const Text("Register Now",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.blue)),
                            )
                          ],
                        ),
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
