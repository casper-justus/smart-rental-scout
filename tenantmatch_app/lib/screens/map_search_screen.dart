import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:dio_cache_interceptor_db_store/dio_cache_interceptor_db_store.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
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
  PropertyListing? _selectedProperty;
  bool _isListView = false;
  CachedTileProvider? _tileProvider;

  static const _defaultCenter = LatLng(37.7749, -122.4194);
  static const _defaultZoom = 13.0;
  static const _maxZoom = 17.0;
  static const _minZoom = 10.0;

  @override
  void initState() {
    super.initState();
    _filteredProps = PropertyListing.sampleProperties;
    _initTileCache();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initLocation());
  }

  Future<void> _initTileCache() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final store = DbCacheStore(databasePath: '${dir.path}/map_tiles.sqlite');
      setState(() {
        _tileProvider = CachedTileProvider(store: store);
      });
    } catch (_) {
      // Tile cache unavailable; map uses default NetworkTileProvider
    }
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
          _mapCtrl.move(LatLng(pos.latitude, pos.longitude), 14);
        }
      }
    } catch (e) {
      if (mounted) {
        showToast(context, 'Could not get current location. Using default.');
      }
    }
  }

  Future<void> _goToMyLocation() async {
    await _initLocation();
    if (mounted) showToast(context, '📍 Centered on your location');
  }

  void _selectProperty(PropertyListing p) {
    setState(() {
      _selectedProperty = p;
      _isListView = false; // Switch to map if selected from suggestions
    });
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
    setState(() {}); // Trigger rebuild for suggestions
    _applyFiltersAndSearch();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: _isListView ? _buildListView(context) : _buildMapView(context),
                ),
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
            // Floating Header (Search Bar + Toggle)
            Positioned(
              top: 16,
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
      ),
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: [
              Icon(Icons.search, color: cs.onSurfaceVariant),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Search neighborhoods...',
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
            initialCenter: _defaultCenter,
            initialZoom: _defaultZoom,
            onTap: (_, __) {
              _clearSelection();
              FocusScope.of(context).unfocus();
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.tenantmatch.app',
              tileProvider: _tileProvider ?? NetworkTileProvider(),
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
        // Zoom Controls
        Positioned(
          right: 16,
          bottom: 220,
          child: _ZoomControls(
            onZoomIn: () => _mapCtrl.move(_mapCtrl.camera.center, _mapCtrl.camera.zoom + 1),
            onZoomOut: () => _mapCtrl.move(_mapCtrl.camera.center, _mapCtrl.camera.zoom - 1),
            onMyLocation: _goToMyLocation,
          ),
        ),
        // Property Summary Card
        if (_selectedProperty != null)
          Positioned(
            left: 16, right: 16, bottom: 120,
            child: _PropertySummaryCard(
              property: _selectedProperty!,
              onTap: () => Navigator.pushNamed(context, '/listing-details', arguments: _selectedProperty!.id),
              onClose: _clearSelection,
            ),
          ),
      ],
    );
  }

  Widget _buildListView(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 140, 16, 16),
      itemCount: _filteredProps.length,
      itemBuilder: (context, index) {
        final p = _filteredProps[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: PropertyCard(
            property: p,
            isFavorite: favoritesService.isFavorite(p.id),
            onTap: () => Navigator.pushNamed(context, '/listing-details', arguments: p.id),
            onFavoriteTap: () => setState(() => favoritesService.toggle(p.id)),
            showTenantScore: true,
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
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(imageUrl: property.imageUrl, width: 70, height: 70, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(property.price, style: AppTextStyle.headlineSm),
                Text(property.address, style: AppTextStyle.bodyMd, maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          IconButton(onPressed: onTap, icon: Icon(Icons.arrow_forward_ios, size: 18, color: cs.primary)),
          IconButton(onPressed: onClose, icon: const Icon(Icons.close, size: 18)),
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
