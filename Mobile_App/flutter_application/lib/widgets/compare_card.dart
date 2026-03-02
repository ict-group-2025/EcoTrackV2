import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../views/air_quality_view_model.dart';
import '../widgets/box_skeleton.dart';
import 'indoor_aqi_panel.dart';
import 'outdoor_aqi_panel.dart';

class CompareCard extends StatelessWidget {
  final Color indoorPanelColor;
  final int? indoorAqi;
  final String indoorQualityLevel;
  final String? indoorPm25Display;

  const CompareCard({
    super.key,
    required this.indoorPanelColor,
    this.indoorAqi,
    required this.indoorQualityLevel,
    this.indoorPm25Display,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Row(
        children: [
          // Outdoor panel — from ViewModel
          Expanded(
            child: Consumer<AirQualityViewModel>(
              builder: (_, vm, __) {
                if (vm.isLoading || vm.currentItem == null) {
                  return const BoxSkeleton(height: 180);
                }
                return OutdoorAQIPanel(
                  aqi: vm.currentAQI ?? 0,
                  qualityLevel: vm.getQualityLevel(),
                  pm25: vm.currentItem?.components.pm25,
                );
              },
            ),
          ),

          // Vertical divider
          Container(width: 1, color: const Color(0xFFE8E6E0)),

          // Indoor panel — from controller/model
          Expanded(
            child: IndoorAQIPanel(
              aqi: indoorAqi,
              qualityLevel: indoorQualityLevel,
              panelColor: indoorPanelColor,
              pm25Display: indoorPm25Display,
            ),
          ),
        ],
      ),
    );
  }
}
