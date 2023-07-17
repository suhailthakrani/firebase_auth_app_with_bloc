// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth_app/bocs/signup/signup_bloc.dart';
import 'package:firebase_auth_app/features/main/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:firebase_auth_app/commons/constants/colors.dart';

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
                      builder: (context) => const MainScreen(),
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
              TextButton(
                onPressed: () {},
                child: const Text("Login"),
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
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child: const Icon(FontAwesomeIcons.phone)),
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
            child: Text("Try without sign up"),
          ),
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String value) onChanged;
  final bool obsecureText;
  final String hint;

  TextInputType keyboardType;

  Widget prefix;

  Widget suffix;
  CustomTextField({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.obsecureText = false,
    this.hint = "",
    this.keyboardType = TextInputType.name,
    this.prefix = const SizedBox(),
    this.suffix = const SizedBox(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorHeight: 25,
      onChanged: onChanged,
      obscureText: obsecureText,
      keyboardType: keyboardType,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: backgroundColor,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
              )),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          prefixIcon: prefix,
          suffixIcon: suffix),
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
