
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final appState = Provider.of<AppState>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildAQICards(),
                const SizedBox(height: 20),
                _buildChartCard(),
                const SizedBox(height: 20),
                _buildSafetyChecklist(),
                const SizedBox(height: 20),
                // _buildSmartHomeSync(appState),
                // const SizedBox(height: 20),
                // _buildAlertsToggle(),
                // const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text(
              'Detailed AQI Analysis',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        IconButton(icon: const Icon(Icons.share), onPressed: () {}),
      ],
    );
  }

  Widget _buildAQICards() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.home, color: Colors.blue[700], size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'INDOOR',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '24',
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Excellent',
                  style: TextStyle(
                    color: Color(0xFF34D399),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.cloud, color: Colors.orange[700], size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'OUTDOOR',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '82',
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Moderate',
                  style: TextStyle(
                    color: Color(0xFFF97316),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChartCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Last 7 Days',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Indoor vs Outdoor Comparison',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildToggle('AQI', true),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Today',
                        ];
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return Text(
                            days[value.toInt()],
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  // Indoor line
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 25),
                      const FlSpot(1, 28),
                      const FlSpot(2, 24),
                      const FlSpot(3, 26),
                      const FlSpot(4, 29),
                      const FlSpot(5, 27),
                      const FlSpot(6, 24),
                    ],
                    isCurved: true,
                    color: const Color(0xFF34D399),
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: const Color(0xFF34D399),
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                  ),
                  // Outdoor line
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 65),
                      const FlSpot(1, 58),
                      const FlSpot(2, 72),
                      const FlSpot(3, 85),
                      const FlSpot(4, 78),
                      const FlSpot(5, 62),
                      const FlSpot(6, 82),
                    ],
                    isCurved: true,
                    color: const Color(0xFFF97316),
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: const Color(0xFFF97316),
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegend(const Color(0xFF34D399), 'Indoor Avg: 26'),
              const SizedBox(width: 24),
              _buildLegend(const Color(0xFFF97316), 'Outdoor Avg: 78'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggle(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.grey[200] : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }

  Widget _buildSafetyChecklist() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.verified_user, color: Colors.blue[600], size: 24),
              const SizedBox(width: 8),
              const Text(
                'Indoor Safety Checklist',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildChecklistItem(
            'HEPA Filter Active',
            'Living room purifier is running optimally',
            true,
          ),
          const Divider(height: 32),
          _buildChecklistItem(
            'Windows Sealed',
            'Preventing outdoor pollutants from entering',
            true,
          ),
          const Divider(height: 32),
          _buildChecklistItem(
            'Cooking Ventilation',
            'Range hood should be used during dinner prep',
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(String title, String subtitle, bool isChecked) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isChecked ? const Color(0xFF34D399) : Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Icon(
            isChecked ? Icons.check : Icons.circle_outlined,
            color: isChecked ? Colors.white : Colors.grey,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: Colors.grey),
      ],
    );
  }

  // Widget _buildSmartHomeSync(AppState appState) {
  //   final devices = appState.getSmartDevices();

  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Icon(Icons.home_filled, color: Colors.blue[600], size: 24),
  //             const SizedBox(width: 8),
  //             const Text(
  //               'Smart Home Sync',
  //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 20),
  //         Row(
  //           children: devices
  //               .map((device) => Expanded(child: _buildDeviceCard(device)))
  //               .toList(),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildDeviceCard(device) {
  //   final isActive = device.status == 'active';

  //   return Container(
  //     margin: const EdgeInsets.only(right: 12),
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.grey[50],
  //       borderRadius: BorderRadius.circular(16),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Icon(
  //               device.type == 'purifier' ? Icons.air : Icons.sensors,
  //               color: Colors.blue[600],
  //               size: 28,
  //             ),
  //             Container(
  //               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //               decoration: BoxDecoration(
  //                 color: isActive ? const Color(0xFFD1FAE5) : Colors.grey[200],
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               child: Text(
  //                 isActive ? 'ACTIVE' : 'STANDBY',
  //                 style: TextStyle(
  //                   fontSize: 10,
  //                   fontWeight: FontWeight.bold,
  //                   color: isActive
  //                       ? const Color(0xFF059669)
  //                       : Colors.grey[600],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 12),
  //         Text(
  //           device.name,
  //           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
  //         ),
  //         const SizedBox(height: 4),
  //         Text(
  //           device.location,
  //           style: TextStyle(color: Colors.grey[600], fontSize: 12),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildAlertsToggle() {
  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     child: Row(
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.all(12),
  //           decoration: BoxDecoration(
  //             color: Colors.orange[50],
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           child: Icon(Icons.warning_amber, color: Colors.orange[700]),
  //         ),
  //         const SizedBox(width: 16),
  //         const Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 'Severe AQI Alerts',
  //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  //               ),
  //               SizedBox(height: 2),
  //               Text(
  //                 'Push notifications for AQI > 150',
  //                 style: TextStyle(color: Colors.grey, fontSize: 13),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Switch(
  //           value: true,
  //           onChanged: (value) {},
  //           activeColor: Colors.orange,
  //         ),
  //       ],
  //     ),
  //   );
  // }
}





