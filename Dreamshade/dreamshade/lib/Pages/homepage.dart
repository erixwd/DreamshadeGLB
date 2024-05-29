import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class Homepage extends StatefulWidget {
  final double endTime;
  final double startTime;
  final double gradientLength;

  const Homepage({
    required this.endTime,
    required this.startTime,
    required this.gradientLength,
    Key? key,
  }) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late double endTime;
  late double startTime;
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    endTime = widget.endTime;
    startTime = widget.startTime;
    _startTimeController.text = widget.startTime.toString();
    _endTimeController.text = widget.endTime.toString();
  }

  void updateGradient({double? newEndTime, double? newStartTime}) {
    setState(() {
      if (newEndTime != null) {
        endTime = newEndTime;
        _endTimeController.text = newEndTime.toString();
      }
      if (newStartTime != null) {
        startTime = newStartTime;
        _startTimeController.text = newStartTime.toString();
      }
    });
  }

  double _convertToRadians(double value) {
    return (value / 24) * 2 * math.pi;
  }

  @override
  Widget build(BuildContext context) {
    double endAngle = _convertToRadians(endTime) + math.pi / 2; // Rotate clockwise by 90 degrees
    double startAngle = _convertToRadians(startTime) + math.pi / 2; // Rotate clockwise by 90 degrees

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dreamshade'),
      ),
      body: Column(
        children: [
          Expanded(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50,),
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: CustomPaint(
                      painter: LinearGradientCirclePainter(
                        startAngle: startAngle,
                        endAngle: endAngle,
                        gradientLength: 0.5, // Fixed gradient length
                      ),
                      child: FractionallySizedBox(
                        widthFactor: 0.75,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('Start Time:'),
                    Expanded(
                      child: TextField(
                        controller: _startTimeController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onSubmitted: (value) {
                          updateGradient(newStartTime: double.tryParse(value));
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('End Time:'),
                    Expanded(
                      child: TextField(
                        controller: _endTimeController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onSubmitted: (value) {
                          updateGradient(newEndTime: double.tryParse(value));
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }
}

class LinearGradientCirclePainter extends CustomPainter {
  final double startAngle;
  final double endAngle;
  final double gradientLength;

  LinearGradientCirclePainter({
    required this.startAngle,
    required this.endAngle,
    required this.gradientLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);

    // Calculate start and end points on the circumference
    final startX = center.dx + radius * math.cos(startAngle);
    final startY = center.dy + radius * math.sin(startAngle);
    final endX = center.dx + radius * math.cos(endAngle);
    final endY = center.dy + radius * math.sin(endAngle);

    // Calculate the midpoint (Point A)
    final midX = (startX + endX) / 2;
    final midY = (startY + endY) / 2;
    final pointA = Offset(midX, midY);

    // Calculate Point B by extending a line through the center
    final vectorX = midX - center.dx;
    final vectorY = midY - center.dy;
    final pointB = Offset(center.dx - vectorX, center.dy - vectorY);

    // Calculate Point C by moving a specific distance from Point A on the line towards Point B
    final diffX = pointB.dx - pointA.dx;
    final diffY = pointB.dy - pointA.dy;
    final length = math.sqrt(diffX * diffX + diffY * diffY);
    final normalizedX = diffX / length;
    final normalizedY = diffY / length;
    final pointC = Offset(
      pointA.dx + normalizedX * gradientLength * radius,
      pointA.dy + normalizedY * gradientLength * radius,
    );


    // Define the gradient
    final gradient = LinearGradient(
      colors: [Color.fromARGB(255, 109, 192, 239), Color.fromARGB(255, 235, 186, 95)],
      begin: Alignment(
        (pointC.dx - center.dx) / radius,
        (pointC.dy - center.dy) / radius,
      ),
      end: Alignment(
        (pointA.dx - center.dx) / radius,
        (pointA.dy - center.dy) / radius,
      ),
    );

    // Create a paint object with the gradient shader
    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: radius));

    // Draw the circle with the gradient
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}