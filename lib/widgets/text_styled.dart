import 'package:flutter/material.dart';

Widget textStyled(String text, double size, Color color, Color shadowColor) {
  return Text(
    text,
    style: TextStyle(
      color: color,
      fontFamily: 'Segoe UI',
      fontSize: size,
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(
          color: shadowColor,
          offset: const Offset(0, 3),
          blurRadius: 6,
        )
      ],
    ),
  );
}
