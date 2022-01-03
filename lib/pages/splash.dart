import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as UI;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  late AnimationController _controller;
  late ui.Image image;
  bool isImageloaded = false;


  @override
  void initState() {
    super.initState();
    init();

    /// Define time for which the logo complete revolution
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _controller.forward();
  }

  /// Initialize Image loading
  Future <void> init() async {
    final ByteData data = await rootBundle.load('assets/images/rocket.png');
    image = await loadImage(Uint8List.view(data.buffer));
  }

  /// Load Image
  Future<ui.Image> loadImage(dynamic img) async {
    final Completer<ui.Image> completer =  Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      setState(() {
        isImageloaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    var safeHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFF6C63FF),
      body: Container(
        padding: EdgeInsets.only(top: safeHeight *0.2),
        child: Column(
            children: [
              AnimatedBuilder(
                  animation: _controller,
                  builder: (context, snapshot) {
                    return Center(
                      child: isImageloaded ? CustomPaint(
                        painter: AtomPaint(
                            image : image,
                            value: _controller.value,
                            width: width
                        ),
                      ) : new Text("Loading"),
                    );
                  }),
              Center(child:Container(height:100,child: Text("My Rocket Company",style: TextStyle(fontWeight: FontWeight.bold),)))
            ]),
      ),
    );
  }
}

class AtomPaint extends CustomPainter {
  AtomPaint({
    required this.value,
    required this.image,
    required this.width
  });

  final double value;
  final ui.Image image;
  final dynamic width;

  /// To increase padding of logo from text increase 3 parameter("width * 0.23").
  @override
  void paint(Canvas canvas, Size size) {
    drawAxis(value, canvas, width * 0.23, Paint()..color = Colors.grey);
  }

  drawAxis(double value, Canvas canvas, double radius, Paint paint) {
    var firstAxis = getCirclePath(radius);
    UI.PathMetrics pathMetrics = firstAxis.computeMetrics();
    for (UI.PathMetric pathMetric in pathMetrics) {
      Path extractPath = pathMetric.extractPath(0, pathMetric.length * value);
      try {
        var metric = extractPath.computeMetrics().first;
        final offset = metric.getTangentForOffset(metric.length)?.position;
        canvas.drawImage(image, offset!, Paint());

      } catch (e) {}}
  }

  Path getCirclePath(double radius) {
    Path path = Path();

    /// Starting angle of animation
    const startAngle = math.pi ;
    const sweepAngle = math.pi*2;
    path.addArc(Rect.fromCircle(center: const Offset(0,0), radius: radius),startAngle,sweepAngle);
    return path;
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}