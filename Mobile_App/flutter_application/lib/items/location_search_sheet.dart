import 'package:flutter/material.dart';
import 'package:flutter_application/controller/osm_search_controller.dart';
import 'package:flutter_application/screens/dashboard/location_search_screen.dart';
import 'package:flutter_application/views/location_view_model.dart';
import 'package:flutter_application/views/search_view_model.dart';
import 'package:provider/provider.dart';

class LocationSearchSheet extends StatelessWidget {
  const LocationSearchSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Change Location',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // Current Location Option
          _buildLocationOption(
            context,
            icon: Icons.my_location,
            iconColor: Colors.blue,
            iconBgColor: Colors.blue.withValues(alpha: 0.1),
            title: 'Current Location',
            subtitle: 'Using GPS',
            onTap: () async{
              // Handle current location 
              Navigator.pop(context);
              final vm = context.read<LocationViewModel>();
              await vm.loadLocation();
             
            },
          ),

          const SizedBox(height: 16),

          // Add Another Location Option
          _buildLocationOption(
            context,
            icon: Icons.search,
            iconColor: Colors.grey[600]!,
            iconBgColor: Colors.grey.withValues(alpha: 0.1),
            title: 'Another Location',
            subtitle: 'Search by city ',
            onTap: () {
              // Handle search location
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (_) =>
                        SearchViewModel(controller: OsmSearchController()),
                    child: const LocationSearchScreen(),
                  ),
                ),
              );
              // Open search screen or dialog
            },
          ),

          const SizedBox(height: 16),

          // Cancel Button
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Add padding for safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildLocationOption(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            // Arrow icon
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 24),
          ],
        ),
      ),
    );
  }
}
