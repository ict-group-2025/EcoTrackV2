
import 'package:flutter/material.dart';
import '../models/data_models.dart';

class PollutantsSection extends StatelessWidget {
  final List<PollutantData> pollutants;

  const PollutantsSection({super.key, required this.pollutants});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pollutants',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildPollutantCard(pollutants[0])),
            const SizedBox(width: 12),
            Expanded(child: _buildPollutantCard(pollutants[1])),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildPollutantCard(pollutants[2])),
            const SizedBox(width: 12),
            Expanded(child: _buildPollutantCard(pollutants[3])),
          ],
        ),
      ],
    );
  }

  Widget _buildPollutantCard(PollutantData pollutant) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                pollutant.symbol,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: pollutant.getStatusColor(),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
      
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: pollutant.value.toString(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: pollutant.unit,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
