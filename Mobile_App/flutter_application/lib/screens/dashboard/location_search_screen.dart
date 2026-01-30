import 'package:flutter/material.dart';
import 'package:flutter_application/models/recent_location.dart';
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
    final locationVM = context.watch<LocationViewModel>();
    final recent = locationVM.recentLocations;

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
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.blue[400],
                              ),
                            );
                          }

                          return Column(
                            children: vm.results.map((r) {
                              final city =
                                  r.address['city'] ?? r.address['state'] ?? '';
                              final country = r.address['country'] ?? '';
                              final subtitle = [
                                city,
                                country,
                              ].where((e) => e.isNotEmpty).join(', ');
                              return _buildSearchResultItem(
                                title: vm.formatLocation(r),
                                subtitle: subtitle.isEmpty
                                    ? 'Unknown'
                                    : subtitle,
                                onTap: () {
                                  final locationVM = context
                                      .read<LocationViewModel>();
                                  final display = vm.formatLocation(r);

                                  locationVM.setManualLocation(
                                    lat: r.lat,
                                    lon: r.lon,
                                    displayName: display,
                                  );

                                  locationVM.addRecentLocation(
                                    RecentLocation(
                                      lat: r.lat,
                                      lon: r.lon,
                                      displayName: display,
                                      country: r.address['country'] ?? '',
                                      city:
                                          r.address['city'] ??
                                          r.address['state'] ??
                                          '',
                                    ),
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
                          _buildRecentSearches(recent),
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
                cursorColor: Colors.black,
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
        leading: Icon(Icons.location_on, color: Colors.blue[400]),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }

  Widget _buildRecentSearches(List<RecentLocation> recent) {
    if (recent.isEmpty) return const SizedBox();

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
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<LocationViewModel>().clearRecentLocations();
              },
              child: Text(
                'Clear All',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        ...recent.map((r) => _buildRecentItem(r)),
      ],
    );
  }

  Widget _buildRecentItem(RecentLocation r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(Icons.history, color: Colors.grey[400]),
        title: Text(r.displayName),
        subtitle: Text(
          [r.city, r.country].where((e) => e.isNotEmpty).join(', '),
        ),
        onTap: () {
          context.read<LocationViewModel>().setManualLocation(
            lat: r.lat,
            lon: r.lon,
            displayName: r.displayName,
          );
          Navigator.pop(context);
        },
      ),
    );
  }
}
