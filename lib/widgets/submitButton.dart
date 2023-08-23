import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color bgColor;
  const SubmitButton(
      {super.key,
      required this.onPressed,
      required this.text,
      required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        height: 55.0,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            elevation: 0.0,
            minimumSize: Size(MediaQuery.of(context).size.width, 150),
            padding: EdgeInsets.symmetric(horizontal: 30),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
          ),
          child: Ink(
            decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: bgColor,
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
                color: bgColor, // Color(0xffF05945),
                borderRadius: BorderRadius.circular(12.0)),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
        ));
  }
}
