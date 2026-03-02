import 'package:flutter/material.dart';

class AlertCard extends StatelessWidget {
  final bool isHazardous;
  final bool alertEnabled;
  final ValueChanged<bool> onToggle;

  const AlertCard({
    super.key,
    required this.isHazardous,
    required this.alertEnabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final Color accentColor = isHazardous
        ? const Color(0xFFD97706)
        : const Color(0xFF059669);

    final Color bgColor = isHazardous
        ? const Color(0xFFFFF0F2)
        : const Color(0xFFF0FDF4);

    final IconData alertIcon = isHazardous
        ? Icons.warning_amber
        : Icons.notifications_active_outlined;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildIcon(bgColor, alertIcon, accentColor),
          const SizedBox(width: 14),
          _buildText(isHazardous),
          Switch(
            value: alertEnabled,
            onChanged: onToggle,
            activeColor: Colors.white,
            activeTrackColor: accentColor,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFDDDDDD),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(Color bg, IconData icon, Color iconColor) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(child: Icon(icon, size: 20, color: iconColor)),
    );
  }

  Widget _buildText(bool isHazardous) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isHazardous ? 'Hazardous Alerts' : 'Air Quality Alerts',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            isHazardous
                ? 'Alerts for AQI above 150'
                : 'Alerts for PM2.5 above 50 µg/m³',
            style: const TextStyle(fontSize: 11, color: Color(0xFF8A8A8A)),
          ),
        ],
      ),
    );
  }
}
