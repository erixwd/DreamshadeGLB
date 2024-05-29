import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

class Homepage extends StatefulWidget {
  final double amplitude;
  final double waveLengthFactor;
  final double gradientControl;
  final Color gradientStartColor;
  final Color gradientEndColor;
  final int customHour;
  final int customMinute;

  const Homepage({
    super.key,
    this.amplitude = 60.0,
    this.waveLengthFactor = 2.0,
    this.gradientControl = 0.5,
    this.gradientStartColor = Colors.red,
    this.gradientEndColor = Colors.blue,
    this.customHour = -1,  // Use system time by default
    this.customMinute = -1,
  });

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Timer _timer;
  double _wavePosition = 0.0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), _updateWavePosition);
    _updateWavePosition(null);
  }

  void _updateWavePosition(Timer? timer) {
    final now = DateTime.now();
    final hour = widget.customHour == -1 ? now.hour : widget.customHour;
    final minute = widget.customMinute == -1 ? now.minute : widget.customMinute;
    final totalMinutes = hour * 60 + minute;
    final fractionOfDay = totalMinutes / (24 * 60);
    setState(() {
      _wavePosition = 360 * fractionOfDay;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size(double.infinity, MediaQuery.of(context).size.height / 2),
                    painter: GridPainter(widget.waveLengthFactor),
                  ),
                  CustomPaint(
                    size: Size(double.infinity, MediaQuery.of(context).size.height / 2),
                    painter: SineWavePainter(
                      wavePosition: _wavePosition,
                      amplitude: widget.amplitude,
                      waveLengthFactor: widget.waveLengthFactor,
                      gradientControl: widget.gradientControl,
                      gradientStartColor: widget.gradientStartColor,
                      gradientEndColor: widget.gradientEndColor,
                    ),
                  ),
                  CustomPaint(
                    size: Size(double.infinity, MediaQuery.of(context).size.height / 2),
                    painter: PointerPainter(
                      wavePosition: _wavePosition,
                      amplitude: widget.amplitude,
                      waveLengthFactor: widget.waveLengthFactor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '05:32 | 19:45',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final double waveLengthFactor;

  GridPainter(this.waveLengthFactor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 2;

    final sectionWidth = size.width / (24 / math.max(waveLengthFactor, 1.0));

    for (double x = 0; x <= size.width * math.max(waveLengthFactor, 1.0); x += sectionWidth) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += 20) {
      paint.color = Colors.grey.withOpacity(y / size.height * 0.5);
      canvas.drawLine(Offset(0, y), Offset(size.width * math.max(waveLengthFactor, 1.0), y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class SineWavePainter extends CustomPainter {
  final double wavePosition;
  final double amplitude;
  final double waveLengthFactor;
  final double gradientControl;
  final Color gradientStartColor;
  final Color gradientEndColor;

  SineWavePainter({
    required this.wavePosition,
    required this.amplitude,
    required this.waveLengthFactor,
    required this.gradientControl,
    required this.gradientStartColor,
    required this.gradientEndColor,
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
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final path = Path();
    final sectionWidth = size.width / 24;

    for (double x = 0; x <= size.width * math.max(waveLengthFactor, 1.0); x++) {
      final angle = (x / waveLengthFactor + wavePosition) * math.pi / 180;
      final y = size.height / 2 + amplitude * math.sin(angle);
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

class PointerPainter extends CustomPainter {
  final double wavePosition;
  final double amplitude;
  final double waveLengthFactor;

  PointerPainter({
    required this.wavePosition,
    required this.amplitude,
    required this.waveLengthFactor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromRGBO(222, 222, 222, 1)
      ..style = PaintingStyle.fill;

    final x = size.width / 2;
    final angle = (x / math.max(waveLengthFactor, 1.0) + wavePosition) * math.pi / 180;
    final y = size.height / 2 + amplitude * math.sin(angle);

    canvas.drawCircle(Offset(x, y), 20, paint); // Increased pointer size
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}