import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../theme/app_theme.dart';
import '../widgets/property_card.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/toast.dart';
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
  PropertyListing? _selectedProperty;

  static const _defaultCenter = LatLng(37.7749, -122.4194);
  static const _defaultZoom = 13.0;
  static const _maxZoom = 17.0;
  static const _minZoom = 10.0;

  @override
  void initState() {
    super.initState();
    _filteredProps = PropertyListing.sampleProperties;
    _initLocation();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _mapCtrl.dispose();
    super.dispose();
  }

  Future<void> _initLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) return;

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 5),
        ),
      );
      if (mounted) {
        _mapCtrl.move(LatLng(pos.latitude, pos.longitude), 14);
      }
    } catch (_) {
      // Location unavailable — fall back to default center
    }
  }

  Future<void> _goToMyLocation() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 8),
        ),
      );
      if (mounted) {
        _mapCtrl.move(LatLng(pos.latitude, pos.longitude), 15);
        showToast(context, '📍 Centered on your location');
      }
    } catch (_) {
      showToast(context, 'Could not get your location');
    }
  }

  void _selectProperty(PropertyListing p) {
    setState(() {
      _selectedProperty = p;
    });
    // Animate map to the selected property
    _mapCtrl.move(LatLng(p.lat, p.lng), 15);
  }

  void _clearSelection() {
    setState(() => _selectedProperty = null);
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

    if (query.isNotEmpty) {
      props = props.where((p) =>
        p.address.toLowerCase().contains(query) ||
        p.neighborhood.toLowerCase().contains(query) ||
        p.price.toLowerCase().contains(query) ||
        p.type.toLowerCase().contains(query)
      ).toList();
    }

    if (_filters.propertyType != 'All') {
      props = props.where((p) => p.type == _filters.propertyType).toList();
    }

    if (_filters.maxPrice < 10000) {
      props = props.where((p) {
        final priceNum = int.tryParse(p.price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        return priceNum <= _filters.maxPrice.toInt();
      }).toList();
    }

    if (_filters.minBeds > 0) {
      props = props.where((p) => p.beds >= _filters.minBeds).toList();
    }

    if (_filters.neighborhood != 'All') {
      props = props.where((p) => p.neighborhood == _filters.neighborhood).toList();
    }

    if (_filters.petsAllowed) {
      props = props.where((p) => p.petsOk).toList();
    }

    setState(() {
      _filteredProps = props;
      _selectedProperty = null;
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
      resizeToAvoidBottomInset: false, // Keep nav bar in place when keyboard opens
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.search, color: cs.onSurfaceVariant),
                    const SizedBox(width: 8),
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
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.containerMargin, vertical: 4),
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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                          const SizedBox(width: 4),
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
            const SizedBox(height: 8),
            Text('No properties match your filters',
                style: AppTextStyle.bodyMd.copyWith(color: cs.onSurfaceVariant)),
          ],
        ),
      );
    }

    return Stack(
      children: [
        // Map
        Positioned.fill(
          child: FlutterMap(
            mapController: _mapCtrl,
          options: MapOptions(
            initialCenter: _defaultCenter,
            initialZoom: _defaultZoom,
            minZoom: _minZoom,
            maxZoom: _maxZoom,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.drag | InteractiveFlag.pinchZoom | InteractiveFlag.doubleTapZoom,
            ),
            onTap: (_, __) {
              FocusScope.of(context).unfocus();
              _clearSelection();
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
                final isSelected = _selectedProperty?.id == p.id;
                final isHot = p.isHot || p.isGreatValue;
                return Marker(
                  point: LatLng(p.lat, p.lng),
                  width: isSelected ? 100 : 80,
                  height: isSelected ? 100 : 80,
                  child: GestureDetector(
                    onTap: () => _selectProperty(p),
                    child: AnimatedScale(
                      scale: isSelected ? 1.25 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSelected ? cs.secondary : cs.primary,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(isSelected ? 0.35 : 0.2),
                                  blurRadius: isSelected ? 8 : 4,
                                ),
                              ],
                            ),
                            child: Text(
                              p.title,
                              style: TextStyle(
                                color: isSelected ? cs.onSecondary : cs.onPrimary,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Icon(
                            isHot ? Icons.local_fire_department : Icons.location_on,
                            color: isSelected ? cs.secondary : (isHot ? Colors.orange : cs.error),
                            size: isSelected ? 32 : (isHot ? 28 : 24),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          ),
        ),
        // Summary card when a property is selected (like Google Maps info window)
        if (_selectedProperty != null)
          Positioned(
            left: AppTheme.containerMargin,
            right: AppTheme.containerMargin,
            bottom: 170,
            child: _PropertySummaryCard(
              property: _selectedProperty!,
              onTap: () => Navigator.pushNamed(context, '/listing-details', arguments: _selectedProperty!.id),
              onClose: _clearSelection,
            ),
          ),
        // Zoom controls
        Positioned(
          right: AppTheme.containerMargin,
          bottom: 180,
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
                    (_mapCtrl.camera.zoom + 1).clamp(_minZoom, _maxZoom),
                  );
                }, context, border: false),
                Divider(height: 1, color: cs.outlineVariant.withOpacity(0.3)),
                _mapBtn(Icons.remove, () {
                  _mapCtrl.move(
                    _mapCtrl.camera.center,
                    (_mapCtrl.camera.zoom - 1).clamp(_minZoom, _maxZoom),
                  );
                }, context, border: false),
                Divider(height: 1, color: cs.outlineVariant.withOpacity(0.3)),
                _mapBtn(Icons.my_location, _goToMyLocation, context, border: false),
              ],
            ),
          ),
        ),
        // Bottom sheet with property list overlay
        Positioned(
          left: 0, right: 0, bottom: 0,
          child: Container(
            constraints: const BoxConstraints(maxHeight: 160),
            decoration: BoxDecoration(
              color: cs.surface.withOpacity(0.95),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, -2),
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
                    margin: const EdgeInsets.only(top: 8, bottom: 4),
                    width: 32, height: 4,
                    decoration: BoxDecoration(
                      color: cs.onSurfaceVariant.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: AppTheme.containerMargin, bottom: 4),
                  child: Text(
                    _selectedProperty != null ? 'Selected property' : 'Tap a pin or scroll listings',
                    style: AppTextStyle.labelCaps.copyWith(color: cs.onSurfaceVariant),
                  ),
                ),
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.containerMargin),
                    itemCount: _filteredProps.length,
                    separatorBuilder: (_, __) => const SizedBox(width: AppTheme.gutter),
                    itemBuilder: (_, i) {
                      final p = _filteredProps[i];
                      final isSel = _selectedProperty?.id == p.id;
                      return SizedBox(
                        width: 220,
                        child: PropertyCard(
                          property: p,
                          isFavorite: favoritesService.isFavorite(p.id),
                          compact: true,
                          onTap: () {
                            _selectProperty(p);
                          },
                          onFavoriteTap: () async {
                            await favoritesService.toggle(p.id);
                            setState(() {});
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 4),
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
            const SizedBox(height: 8),
            Text('No properties match your filters',
                style: AppTextStyle.bodyMd.copyWith(color: cs.onSurfaceVariant)),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                _filters = const FilterOptions();
                _searchCtrl.clear();
                _applyFiltersAndSearch();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.containerMargin),
      physics: const BouncingScrollPhysics(),
      itemCount: _filteredProps.length,
      itemBuilder: (_, i) {
        final p = _filteredProps[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.gutter),
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

/// Google Maps-style summary card shown above the bottom sheet when a pin is tapped.
class _PropertySummaryCard extends StatelessWidget {
  final PropertyListing property;
  final VoidCallback onTap;
  final VoidCallback onClose;

  const _PropertySummaryCard({
    required this.property,
    required this.onTap,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(14),
      shadowColor: Colors.black.withOpacity(0.2),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outlineVariant, width: 0.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
              child: Row(
                children: [
                  // Thumbnail image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 64,
                      height: 64,
                      child: Image.network(
                        property.imageUrl,
                        fit: BoxFit.cover,
                        cacheWidth: 128,
                        cacheHeight: 128,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppTheme.surfaceContainerOf(context),
                          child: Icon(Icons.home, color: cs.onSurfaceVariant, size: 28),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          property.price,
                          style: AppTextStyle.headlineMd.copyWith(color: cs.primary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          property.address,
                          style: AppTextStyle.bodyMd.copyWith(color: cs.onSurfaceVariant),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _miniChip('${property.beds} bed', context),
                            const SizedBox(width: 6),
                            _miniChip('${property.baths} bath', context),
                            if (property.tenantScore > 0) ...[
                              const SizedBox(width: 6),
                              _miniChip('${property.tenantScore}', context,
                                  icon: Icons.analytics_outlined),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // View button
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: cs.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('View', style: AppTextStyle.bodyMd.copyWith(
                        color: cs.onPrimary, fontWeight: FontWeight.w600,
                      )),
                    ),
                  ),
                ],
              ),
            ),
            // Close bar
            GestureDetector(
              onTap: onClose,
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.only(bottom: 8),
                alignment: Alignment.center,
                child: Container(
                  width: 28, height: 3,
                  decoration: BoxDecoration(
                    color: cs.onSurfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniChip(String label, BuildContext context, {IconData? icon}) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowOf(context),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: cs.primary),
            const SizedBox(width: 2),
          ],
          Text(label, style: TextStyle(fontSize: 10, color: cs.onSurfaceVariant)),
        ],
      ),
    );
  }
}
