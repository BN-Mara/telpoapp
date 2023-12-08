import 'package:flutter/material.dart';

InputDecoration myInputDecoration(IconData icon, String labelText) {
  return InputDecoration(
    icon: Icon(
      icon,
      color: Colors.black,
      size: 32.0, /*Color(0xff224597)*/
    ),
    labelText: labelText,
    labelStyle: TextStyle(color: Colors.black54, fontSize: 18.0),
    hintText: '',
    enabledBorder: InputBorder.none,
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black54),
    ),
    border: InputBorder.none,
  );
}
