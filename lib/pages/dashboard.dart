import 'package:cloud_firestore/cloud_firestore.dart';
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

  /// To use Firebase auth
  FirebaseAuth auth = FirebaseAuth.instance;
  /// To use Firebase Firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection(Constants.databaseName).snapshots();
  var uid = FirebaseAuth.instance.currentUser!.uid;



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


  /// Stopwatch
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  /// Set initial time in stopwatch
  void setInitTime() async{
    var collection = FirebaseFirestore.instance.collection(Constants.databaseName).doc(uid);
    var querySnapshot = await collection.get();
    Map<String, dynamic>? data = querySnapshot.data();
    var _time = data!['usageTime'];
    if(_time!=null){
      _stopWatchTimer.setPresetTime(mSec: _time);
    }else{
      if (kDebugMode) {
        print("Usage Time is null");
      }}
    }

    /// Save app usage time in database
  setUsageTime(time)async{
    Future.delayed(const Duration(seconds: 5),(){
      var uid = FirebaseAuth.instance.currentUser!.uid;
      firestore.collection(Constants.databaseName).doc(uid).update(
          {
            "usageTime":time,
          }).then((_){
        if (kDebugMode) {
          print("Updated new time !");
        }
      });
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
    //_stopWatchTimer.setPresetTime(mSec: 3600*100);
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() async{
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    await _stopWatchTimer.dispose();

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        _stopWatchTimer.onExecute
            .add(StopWatchExecute.start);
        if (kDebugMode) {
          print("app in resumed");
        }
        break;
      case AppLifecycleState.inactive:
        _stopWatchTimer.onExecute
            .add(StopWatchExecute.stop);
        if (kDebugMode) {
          print("app in inactive");
        }
        break;
      case AppLifecycleState.paused:
        _stopWatchTimer.onExecute
            .add(StopWatchExecute.stop);
        if (kDebugMode) {
          print("app in paused");
        }
        break;
      case AppLifecycleState.detached:
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
    var safeHeight = size.height - (MediaQuery.of(context).padding.top+kToolbarHeight);
    var width = size.width;


    return Scaffold(
      appBar: AppBar(
        title:  const Text("Dashboard"),
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

          return Container(
            height: safeHeight,
            child: Column(
              children: [
                /// Timer part
                SizedBox(
                  height: safeHeight * 0.1,
                    child: StreamBuilder<int>(
                      stream: _stopWatchTimer.rawTime,
                      initialData: _stopWatchTimer.rawTime.value,
                      builder: (context, snap) {
                        final value = snap.data!;
                        final displayTime =
                        StopWatchTimer.getDisplayTime(value,milliSecond: false);
                        setUsageTime(value);
                        return Row(
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                      child: Text(
                                        displayTime.toString(),
                                        style: const TextStyle(
                                            fontSize: 30,
                                            fontFamily: 'Helvetica',
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                )),
                            ElevatedButton(onPressed: ()async{
                              _stopWatchTimer.setPresetTime(mSec: 3600);
                            }, child: const Text("Set Time"))
                          ],
                        );
                      },
                    ),),
                /// Users List
                SizedBox(
                  height: safeHeight*0.9,
                  child: ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                      //_stopWatchTimer.rawTime.listen((value) =>);
                      return ListTile(
                        title: Text(data['email']?? "null"),
                        //title: Text(stopwatch.elapsed.inSeconds.toString()),
                        subtitle: Text(data['uid']),

                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

}
