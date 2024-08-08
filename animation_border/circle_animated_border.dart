import 'package:flutter/material.dart';
import 'dart:math';


void main()=> runApp(MyApp());

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
        milliseconds: 9000,
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
  
  void startAnimation(){
    if(controller.status == AnimationStatus.completed){
       controller.reset();
    }else{
      controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Material App Bar'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => startAnimation(),
        child:Icon(Icons.start)      
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return CustomPaint(
              foregroundPainter: BorderPainter(currentState: controller.value),
              child: Container(
                decoration : BoxDecoration(
                   color: Colors.white,
                   shape: BoxShape.circle,
                ),
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

  final double currentState;

  BorderPainter({required this.currentState});

  @override
  void paint(Canvas canvas, Size size) {

    double strokeWidth = 6;
    Rect rect = const Offset(0,0) & Size(size.width, size.height);

    var paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

      double startAngle = pi / 2;
      double sweepAmount = 2*currentState * pi;

      canvas.drawArc(rect, startAngle, sweepAmount, false, paint);
  }


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
