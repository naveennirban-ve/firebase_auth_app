import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/pages/signUp.dart';
import 'package:firebase_auth_app/widgets/input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'dashboard.dart';
import 'obsolete/register.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  /// GlobalFormKey
  final _formKey = GlobalKey<FormState>();

  /// To use Firebase Firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// TextControllers for input fields
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  /// FocusNode for auth fields
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  String? _userEmail = "";

  String _responseMessage = "";

  FirebaseAuth auth = FirebaseAuth.instance;




  /// SignInUsingEmailPassword
  Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
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


  /// Dispose Controllers
  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  /// SignIn Anonymously
  Future<void> _signInAnonymously() async {
    try {
      FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
      await FirebaseAuth.instance.signInAnonymously();
      var uid = FirebaseAuth.instance.currentUser!.uid;
      var email = FirebaseAuth.instance.currentUser!.email;
       firestoreInstance.collection("users").doc(uid).set(
          {
            "uid":uid,
            "email": email
          }).then((_){
        if (kDebugMode) {
          print("Successfully registered !");
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      } // TODO: show dialog with error
    }
  }



  /// Tap function for SignIn
  Function? onSignInTap(){
    return () async{
      if (_formKey.currentState!.validate()) {
        User? user = await signInUsingEmailPassword(
            email: _emailTextController.text,
            password: _passwordTextController.text,
            context: context);

        if(user!=null){
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
    };
  }
  /// Tap function for Anonymous Login
  Function? onSignInAnonymouslyTap(){
    return _signInAnonymously;
  }


    @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var safeHeight = size.height - MediaQuery.of(context).padding.top;
    var width = size.width;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: width*0.05,vertical: width*0.05),
        child:
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    //height: width*0.4,
                    //width: width*0.2,
                    child: const Icon(Icons.person_pin,size: 128,color: Colors.grey,),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      ),
                  ),
                  SizedBox(height: safeHeight*0.01,),
                  const Text("Welcome Back",style: TextStyle(fontSize: 36,fontWeight: FontWeight.bold),),
                  SizedBox(height: safeHeight*0.005,),
                  const Text("Sign In to continue",style: TextStyle(color: Colors.grey),),
                  SizedBox(height: safeHeight*0.02,),
                  inputField(_emailTextController, _focusEmail, false, "Email", true, false, null),
                  SizedBox(height: safeHeight*0.01,),
                  inputField(_passwordTextController, _focusPassword, true, "Password", false, true, null),
                  SizedBox(height: safeHeight*0.01,),
                  /// SignIn Button
                  button(onSignInTap,safeHeight,Colors.green,"Submit"),
                  SizedBox(height: safeHeight*0.02,),
                  /// Create a account page link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ",style: TextStyle(fontSize: 16),),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUp()),
                          );
                        },
                        child: const Text("Create a new account",
                            style: TextStyle(

                                color: Colors.green,fontSize: 16,fontWeight: FontWeight.w600)),
                      )
                    ],
                  ),
                  SizedBox(height: safeHeight*0.02,),
                  /// SignIn Anonymously Button
                  button(onSignInAnonymouslyTap,safeHeight,Colors.lightBlueAccent,"Sign In Anonymously"),
                ],
              ),
            ),



      ),
    );
  }
}
