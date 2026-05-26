import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_theme.dart';
import '../widgets/property_card.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../models/property.dart';
import '../main.dart';

class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen({super.key});

  @override
  State<MapSearchScreen> createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
  final _searchCtrl = TextEditingController();
  final MapController _mapCtrl = MapController();
  FilterOptions _filters = const FilterOptions();
  List<PropertyListing> _filteredProps = PropertyListing.sampleProperties;
  bool _showList = false;

  static const _defaultCenter = LatLng(37.7749, -122.4194);
  static const _defaultZoom = 13.0;

  @override
  void initState() {
    super.initState();
    _filteredProps = PropertyListing.sampleProperties;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _mapCtrl.dispose();
    super.dispose();
  }

  void _applyFilters(FilterOptions f) {
    setState(() {
      _filters = f;
      _applyFiltersAndSearch();
    });
  }

  void _applyFiltersAndSearch() {
    var props = PropertyListing.sampleProperties;
    final query = _searchCtrl.text.toLowerCase().trim();

    // Text search
    if (query.isNotEmpty) {
      props = props.where((p) =>
        p.address.toLowerCase().contains(query) ||
        p.neighborhood.toLowerCase().contains(query) ||
        p.price.toLowerCase().contains(query) ||
        p.type.toLowerCase().contains(query)
      ).toList();
    }

    // Filter by type
    if (_filters.propertyType != 'All') {
      props = props.where((p) => p.type == _filters.propertyType).toList();
    }

    // Filter by max price
    if (_filters.maxPrice < 10000) {
      props = props.where((p) {
        final priceNum = int.tryParse(p.price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        return priceNum <= _filters.maxPrice.toInt();
      }).toList();
    }

    // Filter by min beds
    if (_filters.minBeds > 0) {
      props = props.where((p) => p.beds >= _filters.minBeds).toList();
    }

    // Filter by neighborhood
    if (_filters.neighborhood != 'All') {
      props = props.where((p) => p.neighborhood == _filters.neighborhood).toList();
    }

    // Amenities
    if (_filters.petsAllowed) {
      props = props.where((p) => p.petsOk).toList();
    }

    setState(() {
      _filteredProps = props;
    });
  }

  void _onSearchChanged(String value) {
    _applyFiltersAndSearch();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final activeFilterCount = _filters.activeCount;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: EdgeInsets.fromLTRB(AppTheme.containerMargin, 8, AppTheme.containerMargin, 4),
              child: Container(
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cs.outlineVariant),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.search, color: cs.onSurfaceVariant),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Search by address, neighborhood, price...',
                          hintStyle: AppTextStyle.bodyMd.copyWith(color: cs.onSurfaceVariant),
                        ),
                        textInputAction: TextInputAction.search,
                        onChanged: _onSearchChanged,
                      ),
                    ),
                    // Filter button with badge
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet<FilterOptions>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => FilterBottomSheet(
                                current: _filters,
                                onApply: (f) => _applyFilters(f),
                              ),
                            );
                          },
                          child: Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                              color: activeFilterCount > 0 ? cs.primary : cs.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: activeFilterCount > 0 ? cs.primary : cs.outlineVariant,
                              ),
                            ),
                            child: Icon(
                              Icons.tune,
                              size: 18,
                              color: activeFilterCount > 0 ? cs.onPrimary : cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                        if (activeFilterCount > 0)
                          Positioned(
                            top: -2, right: -2,
                            child: Container(
                              width: 18, height: 18,
                              decoration: BoxDecoration(
                                color: cs.error,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '$activeFilterCount',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: cs.onError,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Results count & toggle
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppTheme.containerMargin, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_filteredProps.length} properties found',
                    style: AppTextStyle.bodyMd.copyWith(color: cs.onSurfaceVariant),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _showList = !_showList),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: cs.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: cs.outlineVariant),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _showList ? Icons.map : Icons.list,
                            size: 16, color: cs.primary,
                          ),
                          SizedBox(width: 4),
                          Text(
                            _showList ? 'Map View' : 'List View',
                            style: AppTextStyle.bodyMd.copyWith(
                              color: cs.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Map or List
            Expanded(
              child: _showList ? _buildListView(context) : _buildMapView(context),
            ),
            // Bottom nav
            AppBottomNav(
              currentIndex: 1,
              onTap: (i) {
                if (i == 0) Navigator.pushNamed(context, '/home');
                if (i == 2) Navigator.pushNamed(context, '/saved');
                if (i == 3) Navigator.pushNamed(context, '/profile');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapView(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (_filteredProps.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 64, color: cs.onSurfaceVariant.withOpacity(0.3)),
            SizedBox(height: 8),
            Text('No properties match your filters',
                style: AppTextStyle.bodyMd.copyWith(color: cs.onSurfaceVariant)),
          ],
        ),
      );
    }

    return Stack(
      children: [
        // Real map — Positioned.fill ensures FlutterMap gets proper constraints inside Stack
        Positioned.fill(
          child: FlutterMap(
            mapController: _mapCtrl,
          options: MapOptions(
            initialCenter: _defaultCenter,
            initialZoom: _defaultZoom,
            minZoom: 10,
            maxZoom: 17,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.drag | InteractiveFlag.pinchZoom | InteractiveFlag.doubleTapZoom,
            ),
            onTap: (_, __) {
              // Dismiss keyboard on map tap
              FocusScope.of(context).unfocus();
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.tenantmatch.app',
            ),
            // Property markers
            MarkerLayer(
              markers: _filteredProps.map((p) {
                final isHot = p.isHot || p.isGreatValue;
                return Marker(
                  point: LatLng(p.lat, p.lng),
                  width: 80,
                  height: 80,
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/listing-details', arguments: p.id),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Price label
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: cs.primary,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Text(
                            p.title,
                            style: TextStyle(
                              color: cs.onPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: 2),
                        Icon(
                          isHot ? Icons.local_fire_department : Icons.location_on,
                          color: isHot ? Colors.orange : cs.error,
                          size: isHot ? 28 : 24,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          ),
        ),
        // Zoom controls
        Positioned(
          right: AppTheme.containerMargin,
          bottom: 100,
          child: Container(
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: cs.outlineVariant.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
              ],
            ),
            child: Column(
              children: [
                _mapBtn(Icons.add, () {
                  _mapCtrl.move(
                    _mapCtrl.camera.center,
                    (_mapCtrl.camera.zoom + 1).clamp(10, 17),
                  );
                }, context, border: false),
                Divider(height: 1, color: cs.outlineVariant.withOpacity(0.3)),
                _mapBtn(Icons.remove, () {
                  _mapCtrl.move(
                    _mapCtrl.camera.center,
                    (_mapCtrl.camera.zoom - 1).clamp(10, 17),
                  );
                }, context, border: false),
                Divider(height: 1, color: cs.outlineVariant.withOpacity(0.3)),
                _mapBtn(Icons.my_location, () {
                  // Move to default center as simulated current location
                  _mapCtrl.move(_defaultCenter, 15);
                }, context, border: false),
              ],
            ),
          ),
        ),
        // Bottom sheet with property list overlay
        Positioned(
          left: 0, right: 0, bottom: 0,
          child: Container(
            constraints: BoxConstraints(maxHeight: 160),
            decoration: BoxDecoration(
              color: cs.surface.withOpacity(0.95),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 8, bottom: 4),
                    width: 32, height: 4,
                    decoration: BoxDecoration(
                      color: cs.onSurfaceVariant.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: AppTheme.containerMargin, bottom: 4),
                  child: Text(
                    'Tap a pin or scroll listings',
                    style: AppTextStyle.labelCaps.copyWith(color: cs.onSurfaceVariant),
                  ),
                ),
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: AppTheme.containerMargin),
                    itemCount: _filteredProps.length,
                    separatorBuilder: (_, __) => SizedBox(width: AppTheme.gutter),
                    itemBuilder: (_, i) {
                      final p = _filteredProps[i];
                      return SizedBox(
                        width: 220,
                        child: PropertyCard(
                          property: p,
                          isFavorite: favoritesService.isFavorite(p.id),
                          compact: true,
                          onTap: () => Navigator.pushNamed(context, '/listing-details', arguments: p.id),
                          onFavoriteTap: () async {
                            await favoritesService.toggle(p.id);
                            setState(() {});
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListView(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (_filteredProps.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 64, color: cs.onSurfaceVariant.withOpacity(0.3)),
            SizedBox(height: 8),
            Text('No properties match your filters',
                style: AppTextStyle.bodyMd.copyWith(color: cs.onSurfaceVariant)),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                _filters = const FilterOptions();
                _searchCtrl.clear();
                _applyFiltersAndSearch();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Clear Filters',
                    style: AppTextStyle.bodyMd.copyWith(color: cs.onPrimary, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: AppTheme.containerMargin),
      physics: const BouncingScrollPhysics(),
      itemCount: _filteredProps.length,
      itemBuilder: (_, i) {
        final p = _filteredProps[i];
        return Padding(
          padding: EdgeInsets.only(bottom: AppTheme.gutter),
          child: PropertyCard(
            property: p,
            isFavorite: favoritesService.isFavorite(p.id),
            onTap: () => Navigator.pushNamed(context, '/listing-details', arguments: p.id),
            onFavoriteTap: () async {
              await favoritesService.toggle(p.id);
              setState(() {});
            },
            showTenantScore: true,
          ),
        );
      },
    );
  }

  Widget _mapBtn(IconData icon, VoidCallback onTap, BuildContext context, {bool border = true}) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        alignment: Alignment.center,
        child: Icon(icon, size: 20, color: cs.primary),
      ),
    );
  }
}
