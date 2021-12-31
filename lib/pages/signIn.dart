import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/controllers/validators.dart';
import 'package:firebase_auth_app/widgets/input.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'dashboard.dart';
import 'register.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();

  /// TextControllers for input fields
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  /// FocusNode for auth fields
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
      // print("##########");
      // print(user!.email);
      // print(user!.emailVerified);
      // print(user.uid);
      // print(user!.getIdToken());
      // print("###########");
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

  /// SignIn Anonymously
  Future<void> _signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
  }


   bool checkPassVisibility(isObscure) {
    setState(() {
      isObscure = !isObscure;
    });
    return !isObscure;
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
    };
  }
   Function? onSignInAnonymouslyTap(){
    return _signInAnonymously;
  }


    @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var safeHeight = size.height - MediaQuery.of(context).padding.top;
    var width = size.width;
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: width*0.05,vertical: width*0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                    inputField(_emailTextController, _focusEmail, false, "Email", true, false,null),
                    SizedBox(height: safeHeight*0.01,),
                    inputField(_passwordTextController, _focusPassword, true, "Password", false, true,checkPassVisibility),
                    SizedBox(height: safeHeight*0.01,),
                    /// SignIn button
                    button(onSignInTap,safeHeight,Colors.green,"Submit"),
                    SizedBox(height: safeHeight*0.02,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? ",style: TextStyle(fontSize: 16),),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Register()),
                            );
                          },
                          child: const Text("Create a new account",
                              style: TextStyle(

                                  color: Colors.green,fontSize: 16,fontWeight: FontWeight.w600)),
                        )
                      ],
                    ),
                    SizedBox(height: safeHeight*0.02,),
                    button(onSignInAnonymouslyTap,safeHeight,Colors.lightBlueAccent,"Sign In Anonymously"),
                    // Container(
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(26)
                    //   ),
                    //   child: Card(
                    //     elevation: 5,
                    //     shape:RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(12.0),
                    //     ),
                    //     child: InkWell(
                    //       onTap: () {
                    //         _signInAnonymously();
                    //       },
                    //       child: Container(
                    //           height: safeHeight * 0.07,
                    //           width: double.infinity,
                    //           decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(12),
                    //               color: Colors.green
                    //           ),
                    //           child: const Center(child: Text("Sign in anonymously",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600),))),),
                    //   ),
                    // ),

                  ],
                ),
              ),


          ]),
        ),
      ),
    );
  }
}
