import 'package:flutter/material.dart';

import '../constants/colors.dart';

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
