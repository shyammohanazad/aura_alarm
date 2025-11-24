// --- Live Analog Clock with overlay slot and split painters ---

import 'dart:async';
import 'dart:math' as math;

import 'package:aura_alarm/theme_data.dart';
import 'package:flutter/material.dart';

class AnalogClockWidget extends StatefulWidget {
  final Duration offset;
  // Center overlay is rendered above the face but below hands.
  final Widget? centerOverlay;
  const AnalogClockWidget({
    super.key,
    this.offset = Duration.zero,
    this.centerOverlay,
  });

  @override
  State<AnalogClockWidget> createState() => _AnalogClockWidgetState();
}

class _AnalogClockWidgetState extends State<AnalogClockWidget> {
  late DateTime _now;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now().toUtc().add(widget.offset);
    // Tick every second
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _now = DateTime.now().toUtc().add(widget.offset);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        color: AppColors.surface, // clock face background
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Base face
          CustomPaint(
            painter: const _ClockFacePainter(),
            child: const SizedBox.expand(),
          ),
          // Optional overlay (numbers) below hands
          if (widget.centerOverlay != null) widget.centerOverlay!,
          // Hands above overlay
          CustomPaint(
            painter: _ClockHandsPainter(now: _now),
            child: const SizedBox.expand(),
          ),
          // Center red dot at very top
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: AppColors.secondHand,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

class _ClockFacePainter extends CustomPainter {
  const _ClockFacePainter();

  double _deg2rad(double deg) => deg * math.pi / 180.0;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = math.min(centerX, centerY);

    // Minute/Hour dots around the edge
    final dotPaint = Paint()
      ..color = AppColors.divider
      ..isAntiAlias = true;

    for (int i = 0; i < 60; i++) {
      final angle = _deg2rad(i * 6);
      final dotRadius = i % 5 == 0 ? 3.0 : 2.0; // Hour dots slightly bigger
      canvas.drawCircle(
        Offset(
          centerX + (radius - 10) * math.cos(angle),
          centerY + (radius - 10) * math.sin(angle),
        ),
        dotRadius,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ClockFacePainter oldDelegate) => false;
}

class _ClockHandsPainter extends CustomPainter {
  final DateTime now;
  _ClockHandsPainter({required this.now});

  double _deg2rad(double deg) => deg * math.pi / 180.0;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final center = Offset(centerX, centerY);
    final radius = math.min(centerX, centerY);

    // Angles in degrees
    final hourAngleDeg =
        (now.hour % 12) * 30 + now.minute * 0.5 + now.second * (0.5 / 60);
    final minuteAngleDeg = now.minute * 6 + now.second * 0.1;
    final secondAngleDeg = now.second * 6;

    final hourRad = _deg2rad(hourAngleDeg - 90);
    final minuteRad = _deg2rad(minuteAngleDeg - 90);
    final secondRad = _deg2rad(secondAngleDeg - 90);

    // Minute Hand (Accent)
    final minPaint = Paint()
      ..color = AppColors.accent
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    final minLength = radius * 0.6;
    canvas.drawLine(
      center,
      Offset(
        centerX + minLength * math.cos(minuteRad),
        centerY + minLength * math.sin(minuteRad),
      ),
      minPaint,
    );

    // Hour Hand (Primary)
    final hourPaint = Paint()
      ..color = AppColors.textPrimary
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    final hourLength = radius * 0.4;
    canvas.drawLine(
      center,
      Offset(
        centerX + hourLength * math.cos(hourRad),
        centerY + hourLength * math.sin(hourRad),
      ),
      hourPaint,
    );
    // Second Hand (Red)
    final secPaint = Paint()
      ..color = AppColors.secondHand
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    final secLength = radius * 0.8;
    canvas.drawLine(
      center,
      Offset(
        centerX + secLength * math.cos(secondRad),
        centerY + secLength * math.sin(secondRad),
      ),
      secPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ClockHandsPainter oldDelegate) {
    return oldDelegate.now.second != now.second ||
        oldDelegate.now.minute != now.minute ||
        oldDelegate.now.hour != now.hour;
  }
}
