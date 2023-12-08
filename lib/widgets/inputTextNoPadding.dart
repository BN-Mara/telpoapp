import 'package:flutter/material.dart';

class InputTextNoPadding extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final bool obscureText;
  final keyboardType;
  final controller;
  final bool? readOnly;

  const InputTextNoPadding(
      {required this.labelText,
      required this.icon,
      required this.obscureText,
      required this.keyboardType,
      this.controller,
      this.readOnly})
      : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Material(
        elevation: 15.0,
        shadowColor: Colors.black,
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 15.0),
          child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              autofocus: false,
              keyboardType: keyboardType,
              readOnly: readOnly != null ? readOnly! : false,
              decoration: InputDecoration(
                icon: Icon(
                  icon,
                  color: Colors.black,
                  size: 32.0, /*Color(0xff224597)*/
                ),
                labelText: labelText,
                labelStyle: TextStyle(color: Colors.black54, fontSize: 25.0),
                hintText: '',
                enabledBorder: InputBorder.none,
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54),
                ),
                border: InputBorder.none,
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'le champ de texte est vide!';
                }
              }),
        ),
      ),
    );
  }
}
