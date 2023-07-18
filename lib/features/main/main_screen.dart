import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/bocs/app/app_bloc.dart';
import 'package:firebase_auth_app/bocs/signin/signin_bloc.dart';
import 'package:firebase_auth_app/features/auth/signin/sign_in_screen.dart';
import 'package:firebase_auth_app/repositories/auth_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  final abc = googleSignIn.currentUser;
                  print("-------");
                  print(abc ?? "=============");
                },
                child: Text("Click Me")),
            Text(user != null ? user!.uid : ""),
            Text(user != null ? user!.emailVerified.toString() : ""),
            Text(user != null
                ? user!.displayName.toString()
                : GetStorage().read("name")),
            Text(user != null ? user!.email.toString() : ""),
            Text(user != null ? user!.uid : ""),
            const SizedBox(height: 100),
            BlocConsumer<AppBloc, AppState>(
              listener: (context, state) {
                print(state);
                if (state is AppNavigateState) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => BlocProvider(
                        create: (context) => SignInBloc(AuthRepository()),
                        child: const SignInScreen()),
                  ));
                }
              },
              builder: (context, state) {
                print(state);
                return ElevatedButton(
                    onPressed: () {
                      context.read<AppBloc>().add(AppSignOutEvent(context));
                    },
                    child: const Text("Sign Out"));
              },
            )
          ],
        ),
      ),
    );
  }
}
