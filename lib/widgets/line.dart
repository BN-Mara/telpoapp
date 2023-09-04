import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class Line extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LineState();
}

class _LineState extends State<Line> with SingleTickerProviderStateMixin {
  double _progress = 0.0;
  Animation<double>? animation;
  AnimationController? controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this);

    animation = Tween(begin: 1.0, end: 0.0).animate(controller!)
      ..addListener(() {
        setState(() {
          _progress = animation!.value;
        });
      });

    controller!.forward();
    controller!.repeat();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: LinePainter(_progress));
  }
}

class LinePainter extends CustomPainter {
  Paint? _paint;
  double _progress;

  LinePainter(this._progress) {
    _paint = Paint()
      ..color = redColor.withOpacity(0.2)
      ..strokeWidth = 4.0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
        Offset(0.0, 0.0),
        Offset(size.width - size.width * _progress,
            size.height - size.height * _progress),
        _paint!);
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) {
    return oldDelegate._progress != _progress;
  }
}
