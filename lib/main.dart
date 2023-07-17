// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth_app/features/auth/signin/sign_in_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

import 'package:firebase_auth_app/bocs/signin/signin_bloc.dart';
import 'package:firebase_auth_app/bocs/signup/signup_bloc.dart';
import 'package:firebase_auth_app/features/auth/signup/sign_up_screen.dart';
import 'package:firebase_auth_app/features/main/main_screen.dart';
import 'package:firebase_auth_app/repositories/auth_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  final AuthRepository authRepository = AuthRepository();
  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  const MyApp({
    Key? key,
    required this.authRepository,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
        // RepositoryProvider(
        //   create: (context) => SubjectRepository(),
        // ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SignUpBloc(authRepository),
          ),
          BlocProvider(
            create: (context) => SignInBloc(authRepository),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: box.read("email") != null ? const SignInScreen(): const SignUpScreen(),
        ),
      ),
    );
  }
}
