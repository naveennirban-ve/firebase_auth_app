import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/constants/application.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with WidgetsBindingObserver{
  /// Current Time
  int _currentTime = 0;
  /// Background check flag
  bool _isInForeground = true;
  /// Stopwatch
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );



/*  /// Check internet connectivity
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;*/


  /// To use Firebase auth
  FirebaseAuth auth = FirebaseAuth.instance;
  /// To use Firebase Firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var uid = FirebaseAuth.instance.currentUser!.uid;


  Future<QuerySnapshot> getUserData()async{
    final CollectionReference _usersCollectionRef = FirebaseFirestore.instance.collection(Constants.databaseNameUsers);
    final QuerySnapshot _querySnapshot = await _usersCollectionRef.get();
    return _querySnapshot;
  }



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



  /// Set initial time in stopwatch
  void setInitTime() async{
    var collection = FirebaseFirestore.instance.collection(Constants.databaseNameUserUsage).doc(uid);
    var querySnapshot = await collection.get();
    Map<String, dynamic>? data = querySnapshot.data();
    var _usageTime = data!= null? data['usageTime'] : null;
    if(_usageTime!=null){

      _stopWatchTimer.setPresetSecondTime(_usageTime);
      if (kDebugMode) {
        print("##### Setting time $_usageTime #####");
      }
      return _usageTime;
    }else{
      if (kDebugMode) {
        print("Usage Time is null, setting 0 as default");
      }

    }}

  /// Save app usage time in database
  setUsageTime()async{
    print("##### setUsageTime() called... ###");
     while(_isInForeground) {
       await Future.delayed(const Duration(seconds: Constants.usageDataRequestDelay), () async{
        // Important !!!
        // Always check if state is mounted or not, otherwise async calls will
        // be continued in background.
        if(mounted && _isInForeground ) {
          _currentTime = _stopWatchTimer.secondTime.value;
          // Uid null check
          uid != null ?
          /// Null check because _stopWatchTimer stream gives 0 with actual value.
          _currentTime != 0 ? await firestoreCallback(_currentTime)
              : null : null;
        }
      });
    }
  }

  // Update time async call
   firestoreCallback(_currentTime){
    firestore.collection(Constants.databaseNameUserUsage).doc(uid).update(
        {
          "usageTime": _currentTime,
        }).timeout(Constants.firebaseRequestTimeout).then((_) {
      if (kDebugMode) {
        print("Updated new time ! $_currentTime");
      }
    });
  }




  /// Lifecycle methods
  @override
  void initState() {
    super.initState();
    /// Start activity timer as user visits dashboard
        _stopWatchTimer.onExecute
        .add(StopWatchExecute.start);
    setInitTime();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    _stopWatchTimer.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        setState(() {
          _isInForeground = true;
        });
        _stopWatchTimer.onExecute
            .add(StopWatchExecute.start);
        if (kDebugMode) {
          print("app in resumed");
        }
        break;
      case AppLifecycleState.inactive:
        setState(() {
          _isInForeground = false;
        });

        _stopWatchTimer.onExecute
            .add(StopWatchExecute.stop);
        if (kDebugMode) {
          print("app in inactive");
        }
        break;
      case AppLifecycleState.paused:
        setState(() {
          _isInForeground = false;
        });
        _stopWatchTimer.onExecute
            .add(StopWatchExecute.stop);
        if (kDebugMode) {
          print("app in paused");
        }
        break;
      case AppLifecycleState.detached:
        setState(() {
          _isInForeground = false;
        });
        _stopWatchTimer.onExecute
            .add(StopWatchExecute.stop);
        if (kDebugMode) {
          print("app in detached");
        }
        break;
    }
  }



  @override
  Widget build(BuildContext context) {

    /// Dimension Constraints
    var size = MediaQuery.of(context).size;
    var safeHeight = size.height - (MediaQuery.of(context).padding.top + kToolbarHeight);
    /// Set current usage to db asynchronously.
    // Keep in mind to check state to be mounted to send async requests.
    setUsageTime();
    return Scaffold(
      appBar: AppBar(
        title:  const Text("Dashboard"),
        actions: <Widget>[
          TextButton(
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
      body: FutureBuilder<QuerySnapshot>(
        future: getUserData(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong...'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return SizedBox(
            height: safeHeight,
            child: ListView(
              shrinkWrap: true,
              children: [
                /// Timer part
                SizedBox(
                  height: safeHeight * 0.1,
                    child: mainUI()
                  ,),
                /// Users List
                SizedBox(
                  height: safeHeight*0.9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text("Users",style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                        ),),
                      ),
                      SizedBox(
                        height: safeHeight * 0.86,
                        child: ListView(
                          shrinkWrap: true,
                        children: snapshot.data!.docs.map((DocumentSnapshot document) {
                          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                          return ListTile(
                            title: Text(data['email']?? "null"),
                            subtitle: Text(data['uid']),
                          );
                        }).toList(),
                    ),
                      ),
                  ]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }


  /// Main UI
  Widget mainUI(){

    // Setting initTime directly to initialData param generates bug.
    // So we are setting initial data using setPresetSecondTime() method
    // which sets the stopwatch time to the given, in our case which is
    // what we get from FutureBuilder.
    // print("Stop watch time before clear ${_stopWatchTimer.secondTime.value.toString()}");
     //_stopWatchTimer.clearPresetTime();
    // print("Stop watch time after clear ${_stopWatchTimer.secondTime.value.toString()}");
     //_stopWatchTimer.setPresetSecondTime(initTime);
    // print("Stop watch time after setting new time ${_stopWatchTimer.secondTime.value.toString()}");

    return StreamBuilder<int>(
      stream: _stopWatchTimer.rawTime,
      initialData: 0,
      builder: (context, snap) {
        final value = snap.data!;
        final displayTime =
        StopWatchTimer.getDisplayTime(value,milliSecond: false);

        return Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children :[
              const Text("Total App usage: ",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.blueGrey,
                    fontFamily: 'Helvetica',
                    fontWeight: FontWeight.bold),),
              Text(
              displayTime.toString(),
              style: const TextStyle(
                  fontSize: 30,
                  fontFamily: 'Helvetica',
                  fontWeight: FontWeight.bold,
              color: Colors.grey),
            ),
          ]),
        );
      },
    );
  }
}
