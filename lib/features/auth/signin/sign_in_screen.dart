import 'package:firebase_auth_app/bocs/signup/signup_bloc.dart';
import 'package:firebase_auth_app/features/auth/signup/sign_up_screen.dart';
import 'package:firebase_auth_app/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';

import '../../../bocs/signin/signin_bloc.dart';
import '../../../commons/widgets/custom_textfield.dart';
import '../../main/main_screen.dart';
import '../phone_auth/phone_auth_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            SizedBox(height: height * 0.15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome Back!",
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
                  "Please sign in to your account",
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
              hint: "Enter email",
              controller: emailController,
              onChanged: (String value) {
                context.read<SignInBloc>().add(SignInTextFieldsChangedEvent(
                      value,
                      passController.text,
                    ));
              },
              keyboardType: TextInputType.emailAddress,
              prefix: Icon(Icons.email_outlined,
                  color: Theme.of(context).primaryColor),
            ),
            const SizedBox(height: 6),
            BlocBuilder<SignInBloc, SignInState>(
              builder: (context, state) {
                if (state is SignInErrorState) {
                  final error = state.errors["email"];
                  return error != null
                      ? Text(
                          "* $error",
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12),
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
                context.read<SignInBloc>().add(SignInTextFieldsChangedEvent(
                      emailController.text,
                      value,
                    ));
              },
              keyboardType: TextInputType.visiblePassword,
              prefix: Icon(Icons.lock_outline,
                  color: Theme.of(context).primaryColor),
            ),
            const SizedBox(height: 6),
            BlocBuilder<SignInBloc, SignInState>(
              builder: (context, state) {
                if (state is SignInErrorState) {
                  final error = state.errors["password"];
                  return error != null
                      ? Text(
                          "* $error",
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12),
                        )
                      : const SizedBox();
                } else {
                  return const SizedBox();
                }
              },
            ),
            const SizedBox(height: 20),
            BlocConsumer<SignInBloc, SignInState>(
              listener: (context, state) {
                if (state is SignInNavigateState) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainScreen(),
                      ));
                }
                if (state is SignInInvalidCredentialState) {
                  final loadedState = state;

                  SnackBar snackBar = SnackBar(
                      content: Text(loadedState.error ==
                              "Please check your password or email!"
                          ? "The password is invalid or the user does not have a password."
                          : "Ups Something went wrong. Please try again later"));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    final box = GetStorage();
                    print("-----------${box.read('password')}");
                    print("-----------${box.read('email')}");
                    print(state);
                    context.read<SignInBloc>().add(
                          SignInWithEmailButtonPressedEvent(
                            emailController.text,
                            passController.text,
                          ),
                        );
                    print(state);
                  },
                  child: state is SignInLoadingState
                      ? const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : const Text(
                          "Sign In with email",
                        ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text("Don't have an account?"),
                const SizedBox(width: 10),
                BlocConsumer<SignInBloc, SignInState>(
                  listener: (context, state) {
                    if (state is SignInNavigateState) {
                      context.read<SignUpBloc>().add(const SignUpInitialEvent());
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => SignUpBloc(AuthRepository()),
                              child: const SignUpScreen(),
                            ),
                          ));
                    }
                  },
                  builder: (context, state) {
                    return TextButton(
                      onPressed: () {
                        context
                            .read<SignInBloc>()
                            .add(SignInDontHaveAccountButtonPressedEvent());
                      },
                      child: const Text("Sign Up"),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
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
                        SignUpPhoneButtonPressedEvent(
                          
                        ),
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
                BlocConsumer<SignInBloc, SignInState>(
                  listener: (context, state) {
                    if (state is SignInNavigateState) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainScreen(),
                          ));
                    }
                    if (state is SignInLoadingState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () {
                        context
                            .read<SignInBloc>()
                            .add(SignInGoogleButtonPressedEvent());
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Icon(FontAwesomeIcons.google),
                    );
                  },
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
            BlocConsumer<SignInBloc, SignInState>(
              listener: (context, state) {
                if (context.read<SignInBloc>().state is SignInNavigateState) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainScreen(),
                      ));
                }
                if (state is SignInLoadingState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    context
                        .read<SignInBloc>()
                        .add(SignInContinueAsGuestSignInEvent());
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child: const Text("Continue as Guest"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
