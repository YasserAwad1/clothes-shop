import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    required this.context,
    required this.labelText,
    required this.hintText,
    required this.inputAction,
    required this.myKeyboardType,
    required this.myOnSaved,
    required this.myValidator,
    required this.myController,
    required this.isTextObscure,
  });

  final BuildContext context;
  final String labelText;
  final String hintText;
  final TextInputAction inputAction;
  final TextInputType myKeyboardType;
  final void Function(String? p1)? myOnSaved;
  final String? Function(String? p1)? myValidator;
  final TextEditingController? myController;
  final bool isTextObscure;

  @override
  Widget build(BuildContext context) {
    Color gold = Theme.of(context).colorScheme.secondary;
    return TextFormField(
      cursorColor: gold,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: gold),
        hintText: hintText,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: gold),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: gold),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: gold),
        ),
      ),
      textInputAction: inputAction,
      keyboardType: myKeyboardType,
      onSaved: myOnSaved,
      validator: myValidator,
      controller: myController,
      obscureText: isTextObscure,
    );
  }
}