import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 80.0,
          ),
          child: LayoutBuilder(
            builder: (_, constraints) {
              return Container(
                width: constraints.widthConstraints().maxWidth,
                height: constraints.heightConstraints().maxHeight,
                color: Colors.yellow,
                child: CustomPaint(
                  painter: FaceOutlinePainter(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class FaceOutlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.indigo;

    final redFill = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.red;

    canvas.drawRect(Rect.fromLTWH(20.0, 40.0, 100.0, 100.0),
        paint); // draws normal rectangle in top left corner

    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width - 120.0, 20.0, 100.0,
              100.0), // to put on other side use size argument
          Radius.circular(20.0),
        ),
        paint);

    // Draw mouth
    final mouth = Path()
      ..moveTo(size.width * 0.8, size.height * 0.6)
      ..arcToPoint(
        Offset(size.width * 0.2, size.height * 0.6),
        radius: Radius.circular(15.0),
      )
      ..arcToPoint(Offset(size.width * 0.8, size.height * 0.6),
          radius: Radius.circular(250.0), clockwise: false);
    canvas.drawPath(mouth, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
