import 'package:flutter/material.dart';
import 'package:telpoapp/res/colors.dart';

class BouncedButton extends StatefulWidget {
  const BouncedButton({
    Key? key,
    required this.text,
    required this.iconData,
    this.width = 250,
    this.leftScale = 0.8,
    this.height = 50,
    this.topLeft = 120,
    this.topRight = 0,
    this.bottomLeft = 120,
    this.bottomRight = 300,
    this.topLeft2 = 20,
    this.topRight2 = 20,
    this.bottomLeft2 = 120,
    this.bottomRight2 = 20,
    this.textSize = 24,
    this.iconSize = 30,
    this.animationTime = const Duration(milliseconds: 500),
    this.backgroundColor = primaryWhite,
    this.foregroundColor = primaryColor,
    this.textColor = primaryWhite,
    this.iconColor = primaryColor,
    this.padding = EdgeInsets.zero,
    this.borderRadius = 1,
    this.margin = EdgeInsets.zero,
    this.onPressed,
  }) : super(key: key);
  final String text;
  final IconData iconData;
  final double width,
      leftScale,
      height,
      topLeft,
      topRight,
      bottomLeft,
      bottomRight,
      topLeft2,
      topRight2,
      bottomLeft2,
      bottomRight2,
      textSize,
      borderRadius,
      iconSize;
  final Duration animationTime;
  final Color backgroundColor, foregroundColor, textColor, iconColor;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Function? onPressed;

  @override
  State<BouncedButton> createState() => _BouncedButtonState();
}

class _BouncedButtonState extends State<BouncedButton> {
  late double _width,
      _topRight = 0,
      _topLeft = 120,
      _bottomLeft = 120,
      _bottomRight = 300;
  late double? _iconLeft, _iconRight;
  late Color _iconColor;

  @override
  void initState() {
    _width = widget.width * widget.leftScale;
    _topRight = widget.topRight;
    _topLeft = widget.topLeft;
    _bottomLeft = widget.bottomLeft;
    _bottomRight = widget.bottomRight;
    _iconColor = widget.iconColor;
    _iconLeft = null;
    _iconRight = 15;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 1 / 10,
            width: MediaQuery.of(context).size.width * 3 / 5,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.yellow,
                    Colors.green,
                  ]),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Text(""),
                const Text(
                  "Send Money",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: const Icon(
                      Icons.arrow_right_alt_outlined,
                      size: 25.0,
                      color: Colors.green,
                    ))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
