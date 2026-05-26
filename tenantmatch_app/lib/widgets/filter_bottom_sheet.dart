import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FilterOptions {
  final double maxPrice;
  final int minBeds;
  final String propertyType;
  final bool petsAllowed;
  final bool washerDryer;
  final bool parking;
  final bool gym;
  final String neighborhood;

  const FilterOptions({
    this.maxPrice = 10000,
    this.minBeds = 0,
    this.propertyType = 'All',
    this.petsAllowed = false,
    this.washerDryer = false,
    this.parking = false,
    this.gym = false,
    this.neighborhood = 'All',
  });

  FilterOptions copyWith({
    double? maxPrice,
    int? minBeds,
    String? propertyType,
    bool? petsAllowed,
    bool? washerDryer,
    bool? parking,
    bool? gym,
    String? neighborhood,
  }) {
    return FilterOptions(
      maxPrice: maxPrice ?? this.maxPrice,
      minBeds: minBeds ?? this.minBeds,
      propertyType: propertyType ?? this.propertyType,
      petsAllowed: petsAllowed ?? this.petsAllowed,
      washerDryer: washerDryer ?? this.washerDryer,
      parking: parking ?? this.parking,
      gym: gym ?? this.gym,
      neighborhood: neighborhood ?? this.neighborhood,
    );
  }

  int get activeCount {
    int count = 0;
    if (maxPrice < 10000) count++;
    if (minBeds > 0) count++;
    if (propertyType != 'All') count++;
    if (petsAllowed) count++;
    if (washerDryer) count++;
    if (parking) count++;
    if (gym) count++;
    if (neighborhood != 'All') count++;
    return count;
  }
}

class FilterBottomSheet extends StatefulWidget {
  final FilterOptions current;
  final ValueChanged<FilterOptions> onApply;

  const FilterBottomSheet({
    super.key,
    required this.current,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late double _maxPrice;
  late int _minBeds;
  late String _propertyType;
  late bool _petsAllowed;
  late bool _washerDryer;
  late bool _parking;
  late bool _gym;
  late String _neighborhood;

  final List<String> _propertyTypes = ['All', 'Apartment', 'Condo', 'House', 'Studio'];
  final List<String> _neighborhoods = [
    'All', 'Downtown', 'SoMa', 'Nob Hill', 'Embarcadero', 'Mission', 'St Francis Wood', 'Castro'
  ];
  final List<String> _bedOptions = ['Any', '1+', '2+', '3+', '4+'];

  @override
  void initState() {
    super.initState();
    _maxPrice = widget.current.maxPrice;
    _minBeds = widget.current.minBeds;
    _propertyType = widget.current.propertyType;
    _petsAllowed = widget.current.petsAllowed;
    _washerDryer = widget.current.washerDryer;
    _parking = widget.current.parking;
    _gym = widget.current.gym;
    _neighborhood = widget.current.neighborhood;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12),
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: cs.onSurfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filters', style: AppTextStyle.headlineMd.copyWith(color: cs.primary)),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _maxPrice = 10000;
                      _minBeds = 0;
                      _propertyType = 'All';
                      _petsAllowed = false;
                      _washerDryer = false;
                      _parking = false;
                      _gym = false;
                      _neighborhood = 'All';
                    });
                  },
                  child: Text('Reset', style: AppTextStyle.bodyMd.copyWith(color: cs.secondary)),
                ),
              ],
            ),
          ),
          Divider(color: cs.outlineVariant),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                // Price Range
                _sectionLabel('Max Price', context),
                SizedBox(height: 8),
                _priceSlider(context),
                SizedBox(height: 20),

                // Bedrooms
                _sectionLabel('Bedrooms', context),
                SizedBox(height: 8),
                _chipRow(_bedOptions, _bedLabelIndex, (i) {
                  setState(() {
                    _minBeds = i == 0 ? 0 : i;
                  });
                }, context),
                SizedBox(height: 20),

                // Property Type
                _sectionLabel('Property Type', context),
                SizedBox(height: 8),
                _chipRow(_propertyTypes, _propertyType, (v) {
                  setState(() => _propertyType = v);
                }, context),
                SizedBox(height: 20),

                // Neighborhood
                _sectionLabel('Neighborhood', context),
                SizedBox(height: 8),
                _chipRow(_neighborhoods, _neighborhood, (v) {
                  setState(() => _neighborhood = v);
                }, context),
                SizedBox(height: 20),

                // Amenities
                _sectionLabel('Amenities', context),
                SizedBox(height: 8),
                _toggleTile('Pets Allowed', _petsAllowed, (v) => setState(() => _petsAllowed = v), context),
                _toggleTile('Washer / Dryer', _washerDryer, (v) => setState(() => _washerDryer = v), context),
                _toggleTile('Parking', _parking, (v) => setState(() => _parking = v), context),
                _toggleTile('Gym', _gym, (v) => setState(() => _gym = v), context),
              ],
            ),
          ),
          // Apply button
          Padding(
            padding: EdgeInsets.all(20),
            child: GestureDetector(
              onTap: () {
                widget.onApply(FilterOptions(
                  maxPrice: _maxPrice,
                  minBeds: _minBeds,
                  propertyType: _propertyType,
                  petsAllowed: _petsAllowed,
                  washerDryer: _washerDryer,
                  parking: _parking,
                  gym: _gym,
                  neighborhood: _neighborhood,
                ));
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Apply Filters',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.headlineSm.copyWith(color: cs.onPrimary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text, BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Text(text, style: AppTextStyle.labelCaps.copyWith(color: cs.onSurfaceVariant));
  }

  Widget _priceSlider(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          _maxPrice >= 10000 ? 'Up to \$10,000+' : 'Up to \$${_maxPrice.toStringAsFixed(0)}',
          style: AppTextStyle.headlineSm.copyWith(color: cs.primary),
        ),
        Slider(
          value: _maxPrice,
          min: 1000,
          max: 10000,
          divisions: 18,
          activeColor: cs.primary,
          inactiveColor: cs.outlineVariant,
          label: '\$${_maxPrice.toStringAsFixed(0)}',
          onChanged: (v) => setState(() => _maxPrice = v),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('\$1,000', style: AppTextStyle.bodyMd.copyWith(color: cs.onSurfaceVariant, fontSize: 12)),
          Text('\$10,000+', style: AppTextStyle.bodyMd.copyWith(color: cs.onSurfaceVariant, fontSize: 12)),
        ]),
      ],
    );
  }

  int get _bedLabelIndex {
    if (_minBeds == 0) return 0;
    return _minBeds;
  }

  Widget _chipRow(List<String> items, dynamic selected, ValueChanged<dynamic> onChanged, BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        final sel = selected is String ? selected == item : selected == items.indexOf(item);
        return GestureDetector(
          onTap: () => onChanged(item),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: sel ? cs.primary : cs.surface,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: sel ? cs.primary : cs.outlineVariant),
            ),
            child: Text(
              item,
              style: AppTextStyle.bodyMd.copyWith(
                color: sel ? cs.onPrimary : cs.onSurface,
                fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _toggleTile(String label, bool value, ValueChanged<bool> onChanged, BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyle.bodyMd.copyWith(color: cs.onSurface)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: cs.primary,
          ),
        ],
      ),
    );
  }
}
