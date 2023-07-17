import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

User? user;
 @override
  void initState() {
    intit();
    super.initState();
  }
   intit() async {
    user = FirebaseAuth.instance.currentUser;
  }
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Screen"),
      ),
      body: Column(children: [
        Text(user != null ? user!.uid: ""),
        Text(user != null ? user!.emailVerified.toString(): ""),
        Text(user != null ? user!.displayName.toString(): GetStorage().read("name")),
        Text(user != null ? user!.email.toString(): ""),
        Text(user != null ? user!.uid: ""),
      ],),
    );
  }
}
