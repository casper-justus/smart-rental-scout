import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../widgets/property_card.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/toast.dart';
import '../models/property.dart';
import '../main.dart';

class MapSearchScreen extends StatefulWidget {
  final String? initialQuery;

  const MapSearchScreen({super.key, this.initialQuery});

  @override
  State<MapSearchScreen> createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
  late final TextEditingController _searchCtrl;
  final MapController _mapCtrl = MapController();
  FilterOptions _filters = const FilterOptions();
  List<PropertyListing> _filteredProps = PropertyListing.sampleProperties;
  PropertyListing? _selectedProperty;
  bool _isListView = false;

  static const _defaultCenter = LatLng(-1.2921, 36.8219);
  static const _defaultZoom = 13.0;
  static const _maxZoom = 17.0;
  static const _minZoom = 10.0;
  static const _prefsKeyLat = 'map_last_lat';
  static const _prefsKeyLng = 'map_last_lng';
  static const _prefsKeyZoom = 'map_last_zoom';

  LatLng _initialCenter = _defaultCenter;
  double _initialZoom = _defaultZoom;
  bool _positionRestored = false;
  LatLng? _currentPosition;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController(text: widget.initialQuery ?? '');
    _filteredProps = PropertyListing.sampleProperties;
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _applyFiltersAndSearch();
    }
    _restoreMapPosition();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initLocation());
  }

  Future<void> _restoreMapPosition() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble(_prefsKeyLat);
    final lng = prefs.getDouble(_prefsKeyLng);
    final zoom = prefs.getDouble(_prefsKeyZoom);
    if (lat != null && lng != null && zoom != null) {
      _initialCenter = LatLng(lat, lng);
      _initialZoom = zoom;
      _positionRestored = true;
      if (mounted) {
        _mapCtrl.move(_initialCenter, _initialZoom);
      }
    }
  }

  Future<void> _saveMapPosition() async {
    final prefs = await SharedPreferences.getInstance();
    final center = _mapCtrl.camera.center;
    final zoom = _mapCtrl.camera.zoom;
    await prefs.setDouble(_prefsKeyLat, center.latitude);
    await prefs.setDouble(_prefsKeyLng, center.longitude);
    await prefs.setDouble(_prefsKeyZoom, zoom);
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
      if (!serviceEnabled) {
        if (mounted) showToast(context, 'Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.deniedForever) {
        if (mounted) showToast(context, 'Location permissions are permanently denied.');
        return;
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        final pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 10),
          ),
        );
        if (mounted) {
          _currentPosition = LatLng(pos.latitude, pos.longitude);
        }
      }
    } catch (e) {
      // Silently ignore — user can tap the my-location button to retry.
    }
  }

  Future<void> _goToMyLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) showToast(context, 'Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.deniedForever) {
        if (mounted) showToast(context, 'Location permissions are permanently denied.');
        return;
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        final pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 10),
          ),
        );
        if (mounted) {
          _currentPosition = LatLng(pos.latitude, pos.longitude);
          _mapCtrl.move(_currentPosition!, 14);
        }
      }
    } catch (e) {
      if (mounted) {
        showToast(context, 'Could not get current location. Using default.');
      }
    }
  }

  void _selectProperty(PropertyListing p) {
    setState(() {
      _selectedProperty = p;
      _isListView = false;
    });
    _mapCtrl.move(LatLng(p.lat, p.lng), 15);
  }

  void _clearSelection() {
    setState(() => _selectedProperty = null);
  }

  List<PropertyListing> _getNearbyProperties({int count = 5, LatLng? origin, String? excludeId}) {
    final all = PropertyListing.sampleProperties
        .where((p) => p.id != excludeId)
        .toList();
    if (all.isEmpty) return [];
    final dist = Distance();
    if (origin != null) {
      all.sort((a, b) => dist(LatLng(a.lat, a.lng), origin)
          .compareTo(dist(LatLng(b.lat, b.lng), origin)));
    } else if (_currentPosition != null) {
      all.sort((a, b) => dist(LatLng(a.lat, a.lng), _currentPosition!)
          .compareTo(dist(LatLng(b.lat, b.lng), _currentPosition!)));
    }
    return all.take(count).toList();
  }

  List<PropertyListing> _getNearbyPropertiesFromList({required List<PropertyListing> props, int count = 5}) {
    if (props.isEmpty) return [];
    final list = [...props];
    if (_currentPosition != null) {
      final dist = Distance();
      list.sort((a, b) => dist(LatLng(a.lat, a.lng), _currentPosition!)
          .compareTo(dist(LatLng(b.lat, b.lng), _currentPosition!)));
    }
    return list.take(count).toList();
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
    setState(() {});
    _applyFiltersAndSearch();
  }

  String get _nearYouTitle {
    if (_selectedProperty != null) return 'In the Area';
    if (_searchCtrl.text.trim().isNotEmpty) return 'In the Area';
    return 'Near You';
  }

  List<PropertyListing> get _nearYouProperties {
    if (_selectedProperty != null) {
      return _getNearbyProperties(
        origin: LatLng(_selectedProperty!.lat, _selectedProperty!.lng),
        excludeId: _selectedProperty!.id,
      );
    }
    if (_searchCtrl.text.trim().isNotEmpty) {
      return _getNearbyPropertiesFromList(props: _filteredProps);
    }
    return _getNearbyProperties();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: cs.surface,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: _isListView ? _buildListView(context) : _buildMapView(context),
              ),
              _buildBottomPanel(context),
              AppBottomNav(
                currentIndex: 1,
                onTap: (i) {
                  if (i == 0) Navigator.pushReplacementNamed(context, '/home');
                  if (i == 2) Navigator.pushReplacementNamed(context, '/saved');
                  if (i == 3) Navigator.pushReplacementNamed(context, '/profile');
                },
              ),
            ],
          ),
          Positioned(
            top: topPad + 8,
            left: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSearchBar(context),
                const SizedBox(height: 12),
                _buildViewToggle(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_selectedProperty != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: _PropertySummaryCard(
              property: _selectedProperty!,
              onTap: () => Navigator.pushNamed(context, '/listing-details', arguments: _selectedProperty!.id),
              onClose: _clearSelection,
            ),
          ),
        _NearYouBar(
          title: _nearYouTitle,
          properties: _nearYouProperties,
          onTap: _selectProperty,
        ),
      ],
    );
  }

  Widget _buildViewToggle(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cs.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _toggleBtn('Map', Icons.map, !_isListView),
          _toggleBtn('List', Icons.list, _isListView),
        ],
      ),
    );
  }

  Widget _toggleBtn(String label, IconData icon, bool active) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => setState(() => _isListView = label == 'List'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? cs.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: active ? cs.onPrimary : cs.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: active ? cs.onPrimary : cs.onSurfaceVariant,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final suggestions = _filteredProps.take(5).toList();
    final activeFilterCount = _filters.activeCount;
    final showSuggestions = _searchCtrl.text.isNotEmpty && suggestions.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outlineVariant),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.search, color: cs.onSurfaceVariant),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Search Nairobi neighborhoods...',
                    hintStyle: AppTextStyle.bodyMd.copyWith(color: cs.onSurfaceVariant),
                  ),
                  onChanged: _onSearchChanged,
                ),
              ),
              const SizedBox(width: 8),
              _buildFilterButton(context),
            ],
          ),
        ),
        if (showSuggestions)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cs.outlineVariant),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: Column(
              children: suggestions.map((p) => ListTile(
                leading: const Icon(Icons.location_on_outlined, size: 20),
                title: Text(p.address, style: AppTextStyle.bodyMd, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(p.price, style: const TextStyle(fontSize: 12)),
                onTap: () {
                  _selectProperty(p);
                  _searchCtrl.clear();
                  FocusScope.of(context).unfocus();
                },
              )).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final activeFilterCount = _filters.activeCount;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => FilterBottomSheet(
                current: _filters,
                onApply: _applyFilters,
              ),
            );
          },
          icon: Icon(Icons.tune, color: activeFilterCount > 0 ? cs.primary : cs.onSurfaceVariant),
        ),
        if (activeFilterCount > 0)
          Positioned(
            right: 8, top: 8,
            child: CircleAvatar(
              radius: 8,
              backgroundColor: cs.error,
              child: Text('$activeFilterCount', style: const TextStyle(fontSize: 10, color: Colors.white)),
            ),
          ),
      ],
    );
  }

  Widget _buildMapView(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (_filteredProps.isEmpty) return _EmptyState(onClear: () {
      _searchCtrl.clear();
      _filters = const FilterOptions();
      _applyFiltersAndSearch();
    });

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapCtrl,
          options: MapOptions(
            initialCenter: _initialCenter,
            initialZoom: _initialZoom,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
            onTap: (_, __) {
              _clearSelection();
              FocusScope.of(context).unfocus();
            },
            onMapEvent: (event) {
              if (event is MapEventMoveEnd || event is MapEventFlingAnimationEnd) {
                _saveMapPosition();
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.tenantmatch.app',
              tileProvider: CancellableNetworkTileProvider(),
            ),
            MarkerLayer(
              markers: _filteredProps.map((p) => Marker(
                point: LatLng(p.lat, p.lng),
                width: 60, height: 60,
                child: GestureDetector(
                  onTap: () => _selectProperty(p),
                  child: Icon(
                    Icons.location_on,
                    color: _selectedProperty?.id == p.id ? cs.secondary : cs.primary,
                    size: _selectedProperty?.id == p.id ? 40 : 30,
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: _ZoomControls(
            onZoomIn: () => _mapCtrl.move(_mapCtrl.camera.center, _mapCtrl.camera.zoom + 1),
            onZoomOut: () => _mapCtrl.move(_mapCtrl.camera.center, _mapCtrl.camera.zoom - 1),
            onMyLocation: _goToMyLocation,
          ),
        ),
      ],
    );
  }

  Widget _buildListView(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16, 140 + MediaQuery.of(context).padding.top, 16, 16),
      cacheExtent: 500,
      itemCount: _filteredProps.length,
      itemBuilder: (context, index) {
        final p = _filteredProps[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: RepaintBoundary(
            child: PropertyCard(
              property: p,
              isFavorite: favoritesService.isFavorite(p.id),
              onTap: () => Navigator.pushNamed(context, '/listing-details', arguments: p.id),
              onFavoriteTap: () => setState(() => favoritesService.toggle(p.id)),
              showTenantScore: true,
            ),
          ),
        );
      },
    );
  }
}

class _ZoomControls extends StatelessWidget {
  final VoidCallback onZoomIn, onZoomOut, onMyLocation;
  const _ZoomControls({required this.onZoomIn, required this.onZoomOut, required this.onMyLocation});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FloatingActionButton.small(heroTag: 'zoom_in', onPressed: onZoomIn, child: const Icon(Icons.add)),
        const SizedBox(height: 8),
        FloatingActionButton.small(heroTag: 'zoom_out', onPressed: onZoomOut, child: const Icon(Icons.remove)),
        const SizedBox(height: 8),
        FloatingActionButton.small(heroTag: 'my_loc', onPressed: onMyLocation, child: const Icon(Icons.my_location)),
      ],
    );
  }
}

class _PropertySummaryCard extends StatelessWidget {
  final PropertyListing property;
  final VoidCallback onTap, onClose;
  const _PropertySummaryCard({required this.property, required this.onTap, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: cs.outlineVariant.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: property.imageUrl,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              memCacheWidth: 144,
              memCacheHeight: 144,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  property.price,
                  style: AppTextStyle.headlineSm.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  property.address,
                  style: AppTextStyle.bodyMd.copyWith(
                    color: cs.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.bed_outlined, size: 14, color: cs.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      '${property.beds}',
                      style: AppTextStyle.bodyMd.copyWith(
                        fontSize: 12,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.square_foot_outlined, size: 14, color: cs.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      '${property.sqft} sqft',
                      style: AppTextStyle.bodyMd.copyWith(
                        fontSize: 12,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Material(
            color: cs.primaryContainer.withOpacity(0.4),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_forward_ios, size: 16, color: cs.primary),
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: onClose,
            icon: Icon(Icons.close, size: 20, color: cs.onSurfaceVariant),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

class _NearYouBar extends StatelessWidget {
  final String title;
  final List<PropertyListing> properties;
  final ValueChanged<PropertyListing> onTap;
  const _NearYouBar({
    required this.title,
    required this.properties,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (properties.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: cs.primaryContainer.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.near_me, size: 12, color: cs.primary),
              ),
              const SizedBox(width: 10),
              Text(
                title.toUpperCase(),
                style: AppTextStyle.labelCaps.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              Text(
                'View All',
                style: AppTextStyle.bodyMd.copyWith(
                  fontSize: 12,
                  color: cs.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              cacheExtent: 200,
              itemCount: properties.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final p = properties[i];
                return GestureDetector(
                  onTap: () => onTap(p),
                  child: Container(
                    width: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: cs.surfaceContainerHigh.withOpacity(0.6),
                      border: Border.all(color: cs.outlineVariant.withOpacity(0.3)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(15),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: p.imageUrl,
                            width: 80,
                            height: 110,
                            fit: BoxFit.cover,
                            memCacheWidth: 160,
                            memCacheHeight: 220,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisSize.min,
                              children: [
                                Text(
                                  p.price,
                                  style: AppTextStyle.headlineSm.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  p.neighborhood,
                                  style: AppTextStyle.bodyMd.copyWith(
                                    fontSize: 11,
                                    color: cs.onSurface,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: cs.secondaryContainer.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${p.beds} BR',
                                    style: AppTextStyle.bodyMd.copyWith(
                                      color: cs.secondary,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onClear;
  const _EmptyState({required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('No properties found'),
          TextButton(onPressed: onClear, child: const Text('Clear Filters')),
        ],
      ),
    );
  }
}
