import 'package:flutter/material.dart';

class AirQualityHeader extends StatelessWidget {
  final String? location;
  final bool isConnected;
  final DateTime? lastUpdate;

  const AirQualityHeader({
    super.key,
    this.location,
    required this.isConnected,
    this.lastUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Real-time IoT Device',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            Row(
              children: [
                Text(
                  location?.toUpperCase() ?? 'CONNECTING...',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8A8A8A),
                    letterSpacing: 1.0,
                  ),
                ),
                if (lastUpdate != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isConnected ? Colors.green : Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ],
    );
  }
}
