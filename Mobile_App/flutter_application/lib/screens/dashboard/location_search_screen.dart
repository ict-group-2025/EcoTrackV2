import 'package:flutter/material.dart';
import 'package:flutter_application/views/location_view_model.dart';
import 'package:flutter_application/views/search_view_model.dart';
import 'package:provider/provider.dart';

class LocationSearchScreen extends StatefulWidget {
  const LocationSearchScreen({super.key});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  bool get _isSearching => _searchController.text.trim().isNotEmpty;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  // Mock data - replace with actual data
  final List<String> recentSearches = ['New York, NY', 'London, UK'];

  final List<Map<String, String>> popularCities = [
    {'name': 'Tokyo', 'flag': '🇯🇵'},
    {'name': 'Paris', 'flag': '🇫🇷'},
    {'name': 'Sydney', 'flag': '🇦🇺'},
    {'name': 'Dubai', 'flag': '🇦🇪'},
    {'name': 'Singapore', 'flag': '🇸🇬'},
    {'name': 'Berlin', 'flag': '🇩🇪'},
  ];

  @override
  void initState() {
    super.initState();
    // Auto focus on search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header with search bar
            _buildSearchHeader(),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _isSearching
                    ? Consumer<SearchViewModel>(
                        builder: (context, vm, _) {
                          if (vm.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return Column(
                            children: vm.results.map((r) {
                              return _buildSearchResultItem(
                                title: vm.formatLocation(r),
                                subtitle: r.address['country'] ?? '',
                                onTap: () {
                                  context
                                      .read<LocationViewModel>()
                                      .setManualLocation(
                                        lat: r.lat,
                                        lon: r.lon,
                                        displayName: vm.formatLocation(r),
                                      );

                                  Navigator.pop(context);
                                },
                              );
                            }).toList(),
                          );
                        },
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRecentSearches(),
                          const SizedBox(height: 32),
                          // _buildPopularCities(),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),

          // Search field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(28),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Search location...',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                            });
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  setState(() {});
                  context.read<SearchViewModel>().onQueryChanged(value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultItem({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const Icon(Icons.location_on, color: Colors.redAccent),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'RECENT SEARCHES',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
                letterSpacing: 0.5,
              ),
            ),
            TextButton(
              onPressed: () {
                // Clear all recent searches
              },
              child: const Text(
                'Clear All',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...recentSearches.map((location) => _buildRecentSearchItem(location)),
      ],
    );
  }

  Widget _buildRecentSearchItem(String location) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(Icons.history, color: Colors.grey[400], size: 24),
        title: Text(
          location,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: Icon(Icons.north_west, color: Colors.grey[300], size: 20),
        onTap: () {
          // Handle location selection
          Navigator.pop(context, location);
        },
      ),
    );
  }

  // Widget _buildPopularCities() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'POPULAR CITIES',
  //         style: TextStyle(
  //           fontSize: 13,
  //           fontWeight: FontWeight.bold,
  //           color: Colors.grey[600],
  //           letterSpacing: 0.5,
  //         ),
  //       ),
  //       const SizedBox(height: 16),
  //       GridView.builder(
  //         shrinkWrap: true,
  //         physics: const NeverScrollableScrollPhysics(),
  //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //           crossAxisCount: 2,
  //           crossAxisSpacing: 12,
  //           mainAxisSpacing: 12,
  //           childAspectRatio: 3.5,
  //         ),
  //         itemCount: popularCities.length,
  //         itemBuilder: (context, index) {
  //           return _buildCityCard(
  //             popularCities[index]['name']!,
  //             popularCities[index]['flag']!,
  //           );
  //         },
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildCityCard(String cityName, String flag) {
  //   return InkWell(
  //     onTap: () {
  //       // Handle city selection
  //       Navigator.pop(context, cityName);
  //     },
  //     borderRadius: BorderRadius.circular(16),
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(16),
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(
  //             cityName,
  //             style: const TextStyle(
  //               fontSize: 16,
  //               fontWeight: FontWeight.w600,
  //               color: Colors.black87,
  //             ),
  //           ),
  //           Text(flag, style: const TextStyle(fontSize: 20)),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
