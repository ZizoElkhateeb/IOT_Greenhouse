import 'package:flutter/material.dart';
import 'package:greenhouse/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
Future<void> main() async{
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
      options: const FirebaseOptions(
      apiKey: "AIzaSyByiwtQFAFrffkAWZp088P9VUYOZSn98I4",
      appId: "1:727100546301:android:c5ae589400b09e5d9ab294",
      authDomain: "green-house2-a.firebase.com",
      databaseURL: "https://green-house2-a-default-rtdb.firebaseio.com/",
      storageBucket: "green-house2-a.appspot.com",
      messagingSenderId: "727100546301",
      projectId: "green-house2-a")
      );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Remove the debug banner
      home: LoginScreen(),
    );
  }
}
