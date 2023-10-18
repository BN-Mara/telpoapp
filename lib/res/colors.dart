import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFFfa6d03);
const Color secondaryColor = Color(0xFFf8f9fb);
const Color primaryWhite = Colors.white;
const Color primaryBlack = Color(0xba000000);
const Color errorColor = Colors.red;
const Color successColor = Colors.green;
const Color warningColor = Color.fromARGB(255, 226, 208, 44);
Map<int, Color> color = {
  50: Color.fromRGBO(250, 109, 3, .1),
  100: Color.fromRGBO(250, 109, 3, .2),
  200: Color.fromRGBO(250, 109, 3, .3),
  300: Color.fromRGBO(250, 109, 3, .4),
  400: Color.fromRGBO(250, 109, 3, .5),
  500: Color.fromRGBO(250, 109, 3, .6),
  600: Color.fromRGBO(250, 109, 3, .7),
  700: Color.fromRGBO(250, 109, 3, .8),
  800: Color.fromRGBO(250, 109, 3, .9),
  900: Color.fromRGBO(250, 109, 3, 1),
};
MaterialColor materialPrimary = MaterialColor(0xFFfa6d03, color);
