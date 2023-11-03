import 'package:flutter/material.dart';
import 'package:telpoapp/res/colors.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color bgColor;
  final double? height;
  final IconData? icon;
  const SubmitButton(
      {super.key,
      required this.onPressed,
      required this.text,
      required this.bgColor,
      this.icon,
      this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        height: height ?? 35.0,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            elevation: 0.0,
            minimumSize: Size(MediaQuery.of(context).size.width, 100),
            // padding: EdgeInsets.symmetric(horizontal: 30),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
          ),
          child: Ink(
            decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: bgColor.withOpacity(0.3),
                      blurRadius: 10.0,
                      offset: Offset(0.0, 1.0)),
                ],
                border: Border.all(color: primaryColor, width: 2),
                gradient: LinearGradient(colors: [
                  primaryWhite,
                  primaryColor.withOpacity(0.4),
                  primaryColor.withOpacity(0.8),
                  primaryColor,
                ]),
                //color: bgColor, // Color(0xffF05945),
                borderRadius: BorderRadius.circular(12.0)),
            child: Container(
              alignment: Alignment.center,
              child: Row(children: [
                Expanded(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: Icon(
                          icon ?? Icons.arrow_right_alt_outlined,
                          size: 25.0,
                          color: primaryColor,
                        )))
              ]),
            ),
          ),
        ));
  }
}
