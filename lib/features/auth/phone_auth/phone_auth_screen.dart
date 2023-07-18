import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_text_field/otp_field.dart';

import '../../../bocs/phone/phone_bloc.dart';
import '../../../commons/widgets/custom_textfield.dart';
import '../../main/main_screen.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _phoneNoController = TextEditingController();
  String _otp = '';

   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Phone Authentication"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SizedBox(height:MediaQuery.of(context).size.height * 0.2),
          CustomTextField(
            hint: "Enter Phone Number",
            controller: _phoneNoController,
            onChanged: (String value) {
              context.read<PhoneBloc>().add(
                  PhoneTextFieldsChangedEvent(phone: _phoneNoController.text));
            },
            keyboardType: TextInputType.emailAddress,
            prefix: Icon(Icons.phone_outlined,
                color: Theme.of(context).primaryColor),
          ),
          const SizedBox(height: 6),
          BlocBuilder<PhoneBloc, PhoneState>(
            builder: (context, state) {
              if (state is PhoneErrorState) {
                final error = state.errors["phone"];
                return error != null
                    ? Text(
                        "* $error",
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      )
                    : const SizedBox();
              } else {
                return const SizedBox();
              }
            },
          ),
            const SizedBox(height: 10),
            BlocConsumer<PhoneBloc, PhoneState>(
            listener: (context, state) {
              if (context.read<PhoneBloc>().state is PhoneNavigateState) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(),
                    ));
              }
              if (state is PhoneLoadingState) {
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
                
                  context.read<PhoneBloc>().add(
                        PhoneSendOtpButtonPressedEvent(
                         
                          phone: _phoneNoController.text,
                        ),
                      );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: const Text("Send Otp"),
              );
            },
          ),
          const SizedBox(height: 10),
          OTPTextField(
            controller: OtpFieldController(),
            length: 6,
            onCompleted: (value) {
              setState(() {
                _otp = value;
              });
            },
            
          ),
           const SizedBox(height: 30),
          BlocConsumer<PhoneBloc, PhoneState>(
            listener: (context, state) {
              if (context.read<PhoneBloc>().state is PhoneNavigateState) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(),
                    ));
              }
              if (state is PhoneLoadingState) {
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
                  context.read<PhoneBloc>().add(
                        PhoneVerifyOtpButtonPressedEvent(
                          otp: _otp,
                          
                        ),
                      );
                  
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: const Text("Verify Otp"),
              );
            },
          ),
        ],
      ),
    );
  }
}
