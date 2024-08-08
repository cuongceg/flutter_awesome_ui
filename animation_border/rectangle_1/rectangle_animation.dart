import 'package:flutter/material.dart';


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
              foregroundPainter: BorderPainter(controller.value),
              child: Container(
                decoration : BoxDecoration(
                   color: Colors.white,
                ),
                width: 150,
                height: 200,
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
    double sh = size.height; // For path shortage
    double sw = size.width;  // For path shortage
    double c1 = controller * 4; // Controller value for top and left border.
    double c2 = controller >= 0.25 ? (controller - 0.25) * 4 : 0;
    double c3 = controller >= 0.5 ? (controller - 0.5) * 4 : 0;
    // Controller value for bottom and right border.

    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path top = Path()
      ..lineTo(sw * c1 >= sw ? sw : sw * c1, 0);

    Path left = Path()
      ..moveTo(0,sh)
      ..lineTo(0, c3>=1 ?(2>c3?sh*(2-c3):0) 
               : sh);

    Path right = Path()
      ..moveTo(sw,0)
      ..lineTo(sw,sh * c2 > sh? sh: (c1 >= 1? sh * c1 -sh
              : 0));
    Path bottom =  Path()
      ..moveTo(sw, sh)
      ..lineTo(c2 >= 1 ?(2 < c2? 0:sw*(2-c2)):sw, sh);
 
    canvas.drawPath(top, paint);
    canvas.drawPath(left, paint);
    canvas.drawPath(right, paint);
    canvas.drawPath(bottom, paint);
  }

  @override
  bool shouldRepaint(BorderPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(BorderPainter oldDelegate) => false;
}
