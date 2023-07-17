import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../bocs/signin/signin_bloc.dart';
import '../../../commons/widgets/custom_textfield.dart';
import '../../main/main_screen.dart';

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
        child: Column(
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
                      : SizedBox();
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
                    context.read<SignInBloc>().add(
                          SignInWithEmailButtonPressedEvent(
                            emailController.text,
                            passController.text,
                          ),
                        );
                  },
                  child: const Text(
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
                TextButton(
                  onPressed: () {
                    print(context.read<SignInBloc>().state);
                  },
                  child: const Text("Sign Up"),
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
                ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: const Icon(FontAwesomeIcons.phone)),
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
                        .add(SignInHaveVisitWithoutSignInEvent());
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child: const Text("Try without sign up"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
