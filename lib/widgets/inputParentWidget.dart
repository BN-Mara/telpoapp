import 'package:flutter/material.dart';

class InputParentWidget extends StatelessWidget {
  final Widget child;
  const InputParentWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0),
          child: Container(
            child: Material(
              elevation: 15.0,
              shadowColor: Colors.black,
              borderRadius: BorderRadius.circular(15.0),
              child: Padding(
                  padding: const EdgeInsets.only(right: 20.0, left: 15.0),
                  child: child),
            ),
          ),
        ));
  }
}
