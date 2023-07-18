// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth_app/bocs/signup/signup_bloc.dart';
import 'package:firebase_auth_app/features/auth/phone_auth/phone_auth_screen.dart';
import 'package:firebase_auth_app/features/auth/signin/sign_in_screen.dart';
import 'package:firebase_auth_app/features/main/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:firebase_auth_app/commons/constants/colors.dart';

import '../../../bocs/signin/signin_bloc.dart';
import '../../../commons/widgets/custom_textfield.dart';
import '../../../repositories/auth_repository.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confrimPassController = TextEditingController();
  final phoneNoController = TextEditingController();
  bool showPassword = false;
  bool showConfrimpassword = false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SizedBox(height: height * 0.08),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Hello, Welcome!",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Create your account and get started!",
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.08),
          CustomTextField(
            controller: nameController,
            hint: "Enter name",
            keyboardType: TextInputType.name,
            onChanged: (String value) {
              context.read<SignUpBloc>().add(SignUpTextFieldsChangedEvent(
                    name: value,
                    email: emailController.text,
                    password: passController.text,
                    confrimPassword: confrimPassController.text,
                  ));
            },
            prefix: Icon(Icons.person_outline,
                color: Theme.of(context).primaryColor),
          ),
          const SizedBox(height: 6),
          BlocBuilder<SignUpBloc, SignUpState>(
            builder: (context, state) {
              if (state is SignUpErrorState) {
                final error = state.fieldErrors["name"];
                return error != null
                    ? Text(
                        "* $error",
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      )
                    : SizedBox();
              } else {
                return const SizedBox();
              }
            },
          ),
          const SizedBox(height: 10),
          CustomTextField(
            hint: "Enter email",
            controller: emailController,
            onChanged: (String value) {
              context.read<SignUpBloc>().add(SignUpTextFieldsChangedEvent(
                    name: nameController.text,
                    email: value,
                    password: passController.text,
                    confrimPassword: confrimPassController.text,
                  ));
            },
            keyboardType: TextInputType.emailAddress,
            prefix: Icon(Icons.email_outlined,
                color: Theme.of(context).primaryColor),
          ),
          const SizedBox(height: 6),
          BlocBuilder<SignUpBloc, SignUpState>(
            builder: (context, state) {
              if (state is SignUpErrorState) {
                final error = state.fieldErrors["email"];
                return error != null
                    ? Text(
                        "* $error",
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      )
                    : SizedBox();
              } else {
                return const SizedBox();
              }
            },
          ),
          const SizedBox(height: 10),
          CustomTextField(
            hint: "Enter password",
            controller: passController,
            onChanged: (String value) {
              context.read<SignUpBloc>().add(SignUpTextFieldsChangedEvent(
                    name: nameController.text,
                    email: emailController.text,
                    password: value,
                    confrimPassword: confrimPassController.text,
                  ));
            },
            keyboardType: TextInputType.visiblePassword,
            prefix:
                Icon(Icons.lock_outline, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(height: 6),
          BlocBuilder<SignUpBloc, SignUpState>(
            builder: (context, state) {
              if (state is SignUpErrorState) {
                final error = state.fieldErrors["password"];
                return error != null
                    ? Text(
                        "* $error",
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      )
                    : SizedBox();
              } else {
                return const SizedBox();
              }
            },
          ),
          const SizedBox(height: 10),
          CustomTextField(
            hint: "Confrim Password",
            controller: confrimPassController,
            onChanged: (String value) {
              context.read<SignUpBloc>().add(SignUpTextFieldsChangedEvent(
                    name: nameController.text,
                    email: emailController.text,
                    password: passController.text,
                    confrimPassword: value,
                  ));
            },
            keyboardType: TextInputType.visiblePassword,
            prefix: Icon(
              Icons.lock_outline,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 6),
          BlocBuilder<SignUpBloc, SignUpState>(
            builder: (context, state) {
              if (state is SignUpErrorState) {
                final error = state.fieldErrors["confrimPassword"];
                return error != null
                    ? Text(
                        "* $error",
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      )
                    : SizedBox();
              } else {
                return const SizedBox();
              }
            },
          ),
          const SizedBox(height: 10),
          BlocConsumer<SignUpBloc, SignUpState>(
            listener: (context, state) {
              if (state is SignUpNavigateState) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInScreen(),
                    ));
              }
            },
            builder: (context, state) {
              return ElevatedButton(
                onPressed: () {
                  context.read<SignUpBloc>().add(
                        SignUpWithEmailButtonPressedEvent(
                          name: nameController.text,
                          email: emailController.text,
                          password: passController.text,
                          confrimPassword: confrimPassController.text,
                        ),
                      );
                },
                child: state is SignUpLoadingState
                    ? const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : const Text(
                        "Sign Up",
                      ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text("Already have an account?"),
              const SizedBox(width: 10),
              BlocConsumer<SignUpBloc, SignUpState>(
               listener: (context, state) {
                    if (state is SignUpNavigateState) {
                      context.read<SignInBloc>().add(const SignInInitialEvent());
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => SignInBloc(AuthRepository()),
                              child: const SignInScreen(),
                            ),
                          ));
                    }
                  },
                  builder: (context, state) {
                    return TextButton(
                      onPressed: () {
                        context
                            .read<SignUpBloc>()
                            .add(SignUpAlreadyHaveAccountpEvent());
                      },
                      child: const Text("Login"),
                    );
                  },
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              SizedBox(width: 30),
              Expanded(
                  child: Divider(
                color: Colors.grey,
                height: 3,
              )),
              SizedBox(width: 10),
              Text("Or Continue with"),
              SizedBox(width: 10),
              Expanded(
                  child: Divider(
                color: Colors.grey,
                height: 3,
              )),
              SizedBox(width: 30),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BlocConsumer<SignUpBloc, SignUpState>(
                listener: (context, state) {
                  if (state is SignUpNavigateState) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PhoneAuthScreen(),
                        ));
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                      onPressed: () {
                        print("------------------------");
                        print(state.toString());
                        context.read<SignUpBloc>().add(
                              SignUpPhoneButtonPressedEvent(),
                            );
                        print("------------------------");
                        print(state.toString());
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Icon(FontAwesomeIcons.phone));
                },
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: const Icon(FontAwesomeIcons.google),
              ),
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child: const Icon(FontAwesomeIcons.facebook)),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            child: const Text("Continue as Guest"),
          ),
        ],
      ),
    );
  }
}
