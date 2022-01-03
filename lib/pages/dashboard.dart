import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with WidgetsBindingObserver{
  /// AppState flag
  bool _isInForeground = true;

  /// To use Firebase auth
  FirebaseAuth auth = FirebaseAuth.instance;
  /// To use Firebase Firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('users').snapshots();

  /// General Purpose variables
  late int _counter;

  /// SignOut function
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      } // TODO: show dialog with error
    }
  }



  void counter(isInBackground){
    while(isInBackground){
      Future.delayed( const Duration(seconds: 1),() async{
        setState(() {
          _counter++;
        });
      });
    }
  }

  /// Lifecycle methods
  // @override
  // void initState() {
  //   super.initState();
  //   _counter = 0;
  //   counter(_isInForeground);
  //   WidgetsBinding.instance!.addObserver(this);
  // }
  //
  // @override
  // void dispose() {
  //   WidgetsBinding.instance!.removeObserver(this);
  //   super.dispose();
  // }
  //
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   //_isInForeground = state == AppLifecycleState.resumed;
  //
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       if (kDebugMode) {
  //         _isInForeground=true;
  //         counter(_isInForeground);
  //         print("app in resumed");
  //       }
  //       break;
  //     case AppLifecycleState.inactive:
  //       if (kDebugMode) {
  //         counter(_isInForeground);
  //         _isInForeground=false;
  //         print("app in inactive");
  //       }
  //       break;
  //     case AppLifecycleState.paused:
  //       if (kDebugMode) {
  //         counter(_isInForeground);
  //         _isInForeground=false;
  //         print("app in paused");
  //       }
  //       break;
  //     case AppLifecycleState.detached:
  //       if (kDebugMode) {
  //         counter(_isInForeground);
  //         _isInForeground=false;
  //         print("app in detached");
  //       }
  //       break;
  //   }
  //
  // }
  //


  @override
  Widget build(BuildContext context) {
    //counter(_isInForeground);
    if (kDebugMode) {
      print(_isInForeground);
    }
    return Scaffold(
      appBar: AppBar(
        title:  Text("Dashboard"),

        actions: <Widget>[
          FlatButton(
            child: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: _signOut,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['email'] ?? "null"),
                subtitle: Text(data['uid']),
              );
            }).toList(),
          );
        },
      ),
    );
  }

}
