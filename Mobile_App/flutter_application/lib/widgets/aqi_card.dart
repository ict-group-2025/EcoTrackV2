import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/data_models.dart';

class AQICard extends StatelessWidget {
  final AQIData aqi;

  const AQICard({super.key, required this.aqi});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 180,
            height: 100, // Giảm chiều cao vì chỉ hiển thị nửa
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Background semicircle
                CustomPaint(
                  size: const Size(180, 100),
                  painter: SemiCirclePainter(
                    color: Colors.grey[200]!,
                    strokeWidth: 12,
                    progress: 1.0,
                  ),
                ),
                // Progress semicircle
                CustomPaint(
                  size: const Size(180, 100),
                  painter: SemiCirclePainter(
                    color: aqi.getColor(),
                    strokeWidth: 12,
                    progress: aqi.aqi / 150, // Tính phần trăm progress
                  ),
                ),
                // Text ở giữa
                Positioned(
                  child: Column(
                    
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        '${aqi.aqi}',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'US AQI',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: aqi.getColor().withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${aqi.quality.toUpperCase()} QUALITY',
              style: TextStyle(
                color: aqi.getColor(),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter để vẽ nửa hình tròn
class SemiCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double progress;

  SemiCirclePainter({
    required this.color,
    required this.strokeWidth,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - strokeWidth / 2;

    // Vẽ nửa hình tròn từ 180 độ (bên trái) đến 0 độ (bên phải)
    // progress = 0 -> không có gì
    // progress = 1 -> nửa hình tròn đầy đủ
    final sweepAngle = math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi, // Bắt đầu từ 180 độ (bên trái)
      sweepAngle, // Góc quét
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(SemiCirclePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
