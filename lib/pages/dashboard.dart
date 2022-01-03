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

  /// SignOut function
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
  }


  /// Lifecycle methods
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _isInForeground = state == AppLifecycleState.resumed;
    // switch (state) {
    //   case AppLifecycleState.resumed:
    //     if (kDebugMode) {
    //       print("app in resumed");
    //     }
    //     break;
    //   case AppLifecycleState.inactive:
    //     if (kDebugMode) {
    //       print("app in inactive");
    //     }
    //     break;
    //   case AppLifecycleState.paused:
    //     if (kDebugMode) {
    //       print("app in paused");
    //     }
    //     break;
    //   case AppLifecycleState.detached:
    //     if (kDebugMode) {
    //       print("app in detached");
    //     }
    //     break;
    // }

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
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
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
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
