import 'package:flutter/material.dart';
import 'dart:math' as math;

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // Control variables
  double waveAmplitude = 85;
  double containerPosition = 0.667; // Value between 0 and 1
  double frequency = 0.124; // Frequency of the wave
  double waveHorizontalPosition = 1.5; // Value between 0 and 1

  @override
  void initState() {
    super.initState();
    _updateWavePosition();
  }

  void _updateWavePosition() {
    final currentTime = DateTime.now();
    final minutesInDay = currentTime.hour * 60 + currentTime.minute;
    final totalMinutesInDay = 24 * 60;
    final waveHorizontalPosition = 1.5 - (1.0 * minutesInDay / totalMinutesInDay);

    setState(() {
      this.waveHorizontalPosition = waveHorizontalPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height / 2;
    final containerWidth = screenWidth * 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dreamshade'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  color: Colors.transparent,
                ),
                Center(
                  child: Stack(
                    children: [
                      Transform.translate(
                        offset: Offset(
                          -((containerPosition - 0.5) * containerWidth) + (screenWidth / 2),
                          0,
                        ),
                        child: SizedBox(
                          width: containerWidth,
                          height: screenHeight,
                          child: CustomPaint(
                            size: Size(containerWidth, screenHeight),
                            painter: SineWavePainter(
                              wavePosition: waveHorizontalPosition,
                              amplitude: waveAmplitude,
                              frequency: frequency,
                              gradientControl: 0.7,
                              gradientStartColor: Color.fromARGB(255, 244, 162, 54),
                              gradientEndColor: Color.fromARGB(255, 175, 219, 255),
                              blurSigma: 4.0, // Add blur effect
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth / 2,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: 2,
                          color: Colors.grey.withOpacity(0.1),
                        ),
                      ),
                      Positioned(
                        left: containerWidth / 3,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: 2,
                          color: Colors.red.withOpacity(0.5),
                        ),
                      ),
                      Positioned(
                        left: 2 * containerWidth / 3,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: 2,
                          color: Colors.red.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SineWavePainter extends CustomPainter {
  final double wavePosition;
  final double amplitude;
  final double frequency;
  final double gradientControl;
  final Color gradientStartColor;
  final Color gradientEndColor;
  final double blurSigma; // Add blur effect

  SineWavePainter({
    required this.wavePosition,
    required this.amplitude,
    required this.frequency,
    required this.gradientControl,
    required this.gradientStartColor,
    required this.gradientEndColor,
    required this.blurSigma, // Add blur effect
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          gradientStartColor,
          gradientEndColor,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        stops: [0, gradientControl],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma); // Add blur effect

    final path = Path();
    final waveLength = size.width / 4 / frequency;

    for (double x = 0; x <= size.width; x++) {
      final angle = (x / waveLength) * 2 * math.pi - (wavePosition * 2 * math.pi);
      final y = size.height / 2 - amplitude * math.sin(angle);
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

void main() {
  runApp(MaterialApp(home: Homepage()));
}