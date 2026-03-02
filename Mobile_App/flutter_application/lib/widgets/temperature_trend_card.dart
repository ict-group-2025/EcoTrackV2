import 'package:flutter/material.dart';
import 'dart:math' as math;

class TemperaturePoint {
  final String label;
  final int temp;

  const TemperaturePoint({required this.label, required this.temp});
}

class TemperatureTrendCard extends StatelessWidget {
  final List<TemperaturePoint> data;
  final bool isLoading;
  final String? error;

  const TemperatureTrendCard({
    super.key,
    this.data = const [
      TemperaturePoint(label: 'NOW', temp: 25),
      TemperaturePoint(label: '1H', temp: 24),
      TemperaturePoint(label: '2H', temp: 23),
      TemperaturePoint(label: '3H', temp: 22),
      TemperaturePoint(label: '4H', temp: 21),
      TemperaturePoint(label: '5H', temp: 20),
    ],
    this.isLoading = false,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    final displayData = error != null
        ? const [
            TemperaturePoint(label: 'NOW', temp: 25),
            TemperaturePoint(label: '1H', temp: 24),
            TemperaturePoint(label: '2H', temp: 23),
            TemperaturePoint(label: '3H', temp: 22),
            TemperaturePoint(label: '4H', temp: 21),
            TemperaturePoint(label: '5H', temp: 20),
          ]
        : data;

    return Container(
      width: 360,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TEMPERATURE TREND',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: Color(0xFF2D3748),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F4F8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      error != null ? Icons.error_outline : Icons.trending_down,
                      size: 14,
                      color: error != null
                          ? Colors.red.shade400
                          : Colors.blue.shade400,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isLoading
                          ? 'Loading...'
                          : (error != null ? 'Error' : 'Next 6h'),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: error != null
                            ? Colors.red.shade400
                            : Colors.blue.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Temperature labels row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: displayData
                .map((p) => _TempLabel(label: p.label, temp: p.temp))
                .toList(),
          ),

          const SizedBox(height: 8),

          // Chart
          SizedBox(
            height: 100,
            child: isLoading
                ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                : CustomPaint(
                    size: const Size(double.infinity, 100),
                    painter: _TemperatureChartPainter(
                      temps: displayData.map((p) => p.temp.toDouble()).toList(),
                    ),
                  ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _TempLabel extends StatelessWidget {
  final String label;
  final int temp;

  const _TempLabel({required this.label, required this.temp});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$temp°',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D3748),
          ),
        ),
      ],
    );
  }
}

class _TemperatureChartPainter extends CustomPainter {
  final List<double> temps;

  _TemperatureChartPainter({required this.temps});

  @override
  void paint(Canvas canvas, Size size) {
    if (temps.isEmpty) return;

    final double minTemp = temps.reduce(math.min);
    final double maxTemp = temps.reduce(math.max);
    final double tempRange = maxTemp - minTemp == 0 ? 1 : maxTemp - minTemp;
    final double padding = 10;

    List<Offset> points = [];
    for (int i = 0; i < temps.length; i++) {
      final double x = i / (temps.length - 1) * size.width;
      final double normalised = (temps[i] - minTemp) / tempRange;
      final double y =
          size.height - padding - normalised * (size.height - padding * 2);
      points.add(Offset(x, y));
    }

    // Build smooth path using cubic bezier
    Path linePath = Path();
    Path fillPath = Path();

    linePath.moveTo(points[0].dx, points[0].dy);
    fillPath.moveTo(points[0].dx, size.height);
    fillPath.lineTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final cp1 = Offset((points[i].dx + points[i + 1].dx) / 2, points[i].dy);
      final cp2 = Offset(
        (points[i].dx + points[i + 1].dx) / 2,
        points[i + 1].dy,
      );
      linePath.cubicTo(
        cp1.dx,
        cp1.dy,
        cp2.dx,
        cp2.dy,
        points[i + 1].dx,
        points[i + 1].dy,
      );
      fillPath.cubicTo(
        cp1.dx,
        cp1.dy,
        cp2.dx,
        cp2.dy,
        points[i + 1].dx,
        points[i + 1].dy,
      );
    }

    fillPath.lineTo(points.last.dx, size.height);
    fillPath.close();

    // Fill gradient
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.blue.withOpacity(0.18), Colors.blue.withOpacity(0.02)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // Line
    final linePaint = Paint()
      ..color = Colors.blue.shade300
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(linePath, linePaint);

    // Dots at each point
    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final dotBorderPaint = Paint()
      ..color = Colors.blue.shade400
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (final point in points) {
      canvas.drawCircle(point, 4, dotPaint);
      canvas.drawCircle(point, 4, dotBorderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
