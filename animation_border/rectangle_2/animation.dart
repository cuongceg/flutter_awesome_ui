import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Border Animation',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 2000,
      ),
    );
    animation = controller
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reset();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Material App Bar'),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return CustomPaint(
              foregroundPainter: BorderPainter(controller.value),
              child: Container(
                color: Colors.white,
                width: 150,
                height: 150,
              ),
            );
          },
        ),
      ),
    );
  }
}

class BorderPainter extends CustomPainter {
  final double controller;

  BorderPainter(this.controller);

  @override
  void paint(Canvas canvas, Size size) {
    double _sh = size.height; // For path shortage
    double _sw = size.width; // For path shortage
    double _line = 30.0; // Length of the animated line
    double _c1 = controller * 2; // Controller value for top and left border.
    double _c2 = controller >= 0.5
        ? (controller - 0.5) * 2
        : 0; // Controller value for bottom and right border.

    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    Path _top = Path()
      ..moveTo(_sw * _c1 > _sw ? _sw : _sw * _c1, 0)
      ..lineTo(_sw * _c1 + _line >= _sw ? _sw : _sw * _c1 + _line, 0);

    Path _left = Path()
      ..moveTo(0, _sh * _c1 > _sh ? _sh : _sh * _c1)
      ..lineTo(0, _sh * _c1 + _line >= _sh ? _sh : _sh * _c1 + _line);

    Path _right = Path()
      ..moveTo(_sw, _sh * _c2)
      ..lineTo(
          _sw,
          _sh * _c2 + _line > _sh
              ? _sh
              : _sw * _c1 + _line >= _sw
                  ? _sw * _c1 + _line - _sw
                  : _sh * _c2);

    Path _bottom = Path()
      ..moveTo(_sw * _c2, _sh)
      ..lineTo(
          _sw * _c2 + _line > _sw
              ? _sw
              : _sh * _c1 + _line >= _sh
                  ? _sh * _c1 + _line - _sh
                  : _sw * _c2,
          _sh);

    canvas.drawPath(_top, paint);
    canvas.drawPath(_left, paint);
    canvas.drawPath(_right, paint);
    canvas.drawPath(_bottom, paint);
  }

  @override
  bool shouldRepaint(BorderPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(BorderPainter oldDelegate) => false;
}
