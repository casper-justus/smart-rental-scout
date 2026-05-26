import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/property_card.dart';
import '../widgets/bottom_nav.dart';
import '../models/property.dart';
import '../main.dart';
import '../widgets/app_dialog.dart';

class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen({super.key});

  @override
  State<MapSearchScreen> createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
  final _searchCtrl = TextEditingController();
  final Set<int> _selectedChips = {};
  double _zoom = 1.0;

  final _chips = ['Price', '1-2 Beds', 'Apartment', 'More'];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final props = PropertyListing.sampleProperties;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(AppTheme.containerMargin, 8, AppTheme.containerMargin, 8),
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
                          hintText: 'Search neighborhoods, zips...',
                          hintStyle: AppTextStyle.bodyMd.copyWith(color: cs.onSurfaceVariant),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => showAppAlert(context, 'Filters', 'Price Range: \$500 – \$5,000 · Bedrooms: 1–4 · Property Type: Apartment, House, Condo · Amenities: Parking, Gym, Laundry, Pets'),
                      child: Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: cs.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.tune, size: 18, color: cs.onPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: AppTheme.containerMargin),
                itemCount: _chips.length,
                itemBuilder: (_, i) {
                  final sel = _selectedChips.contains(i);
                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() { sel ? _selectedChips.remove(i) : _selectedChips.add(i); }),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: sel ? cs.secondaryContainer : cs.surface,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: sel ? cs.secondaryContainer : cs.outlineVariant),
                        ),
                        child: Text(_chips[i], style: AppTextStyle.bodyMd.copyWith(
                          color: sel ? cs.onSecondaryContainer : cs.onSurface,
                          fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                        )),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: Stack(
                children: [
                  Transform.scale(
                    scale: _zoom,
                    child: Container(
                      color: AppTheme.surfaceContainerHighOf(context),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.map, size: 64, color: cs.onSurfaceVariant.withOpacity(0.3)),
                          SizedBox(height: 8),
                          Text('Map View', style: AppTextStyle.bodyMd.copyWith(color: cs.onSurfaceVariant)),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0, left: 0, right: 0,
                    child: Container(
                      padding: EdgeInsets.all(AppTheme.containerMargin),
                      decoration: BoxDecoration(
                        color: cs.surface.withOpacity(0.95),
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('124 properties found', style: AppTextStyle.headlineSm.copyWith(color: cs.onSurfaceVariant)),
                          SizedBox(height: AppTheme.spacingSm),
                          SizedBox(
                            height: 190,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: props.length,
                              separatorBuilder: (_, __) => SizedBox(width: AppTheme.gutter),
                              itemBuilder: (_, i) {
                                final p = props[i];
                                return SizedBox(
                                  width: 220,
                                  child: PropertyCard(
                                    property: p,
                                    isFavorite: favoritesService.isFavorite(p.id),
                                    onTap: () => Navigator.pushNamed(context, '/listing-details'),
                                    onFavoriteTap: () async {
                                      await favoritesService.toggle(p.id);
                                      setState(() {});
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: AppTheme.containerMargin,
                    top: 240,
                    child: Column(
                      children: [
                        _mapBtn(Icons.my_location, () => showAppAlert(context, 'Finding Location', 'Using GPS to determine your current location…'), context),
                        SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: cs.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: cs.outlineVariant.withOpacity(0.3)),
                          ),
                          child: Column(
                            children: [
                              _mapBtn(Icons.add, () => setState(() { _zoom = (_zoom + 0.2).clamp(0.5, 3.0); }), context, border: false),
                              Divider(height: 1, color: cs.outlineVariant.withOpacity(0.3)),
                              _mapBtn(Icons.remove, () => setState(() { _zoom = (_zoom - 0.2).clamp(0.5, 3.0); }), context, border: false),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0, right: 0, bottom: 8,
                    child: SizedBox(
                      height: 130,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: AppTheme.containerMargin),
                        itemCount: 2,
                        separatorBuilder: (_, __) => SizedBox(width: AppTheme.gutter),
                        itemBuilder: (_, i) {
                          final p = props[i];
                          return SizedBox(
                            width: 200,
                            child: PropertyCard(
                              property: p,
                              isFavorite: favoritesService.isFavorite(p.id),
                              onTap: () => Navigator.pushNamed(context, '/listing-details'),
                              onFavoriteTap: () async {
                                await favoritesService.toggle(p.id);
                                setState(() {});
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
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

  Widget _mapBtn(IconData icon, VoidCallback onTap, BuildContext context, {bool border = true}) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: border ? BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: cs.outlineVariant.withOpacity(0.3)),
        ) : null,
        child: Icon(icon, size: 20, color: cs.primary),
      ),
    );
  }
}
