import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_dialog.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/toast.dart';
import '../models/property.dart';
import '../main.dart';

class ListingDetailsScreen extends StatefulWidget {
  const ListingDetailsScreen({super.key});

  @override
  State<ListingDetailsScreen> createState() => _ListingDetailsScreenState();
}

class _ListingDetailsScreenState extends State<ListingDetailsScreen> {
  final p = PropertyListing.sampleProperties[0];
  late bool _isFav;

  @override
  void initState() {
    super.initState();
    _isFav = favoritesService.isFavorite(p.id);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(showBack: true),
            Expanded(
              child: ListView(
                children: [
                  // Hero image
                  Semantics(
                    label: 'Property image of ${p.address}',
                    child: Stack(
                      children: [
                        Container(
                          height: 250,
                          width: double.infinity,
                          color: AppTheme.surfaceContainerOf(context),
                          child: Image.network(p.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(Icons.home,
                                  size: 64, color: cs.onSurfaceVariant)),
                        ),
                        if (p.isHot)
                          Semantics(
                            label: 'Hot property',
                            child: Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: cs.surface,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.local_fire_department,
                                          size: 14, color: cs.secondary),
                                      SizedBox(width: 4),
                                      Text('HOT', style: AppTextStyle.labelCaps),
                                    ]),
                              ),
                            ),
                          ),
                        Semantics(
                          label: 'Tenant score ${p.tenantScore} out of 100',
                          child: Positioned(
                            bottom: 12,
                            left: 12,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: cs.secondaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('TENANT SCORE',
                                        style: AppTextStyle.labelCaps.copyWith(
                                            color: cs.onSecondaryContainer,
                                            fontSize: 10)),
                                    Text('${p.tenantScore}/100',
                                        style: AppTextStyle.headlineSm.copyWith(
                                            color: cs.onSecondaryContainer)),
                                  ]),
                            ),
                          ),
                        ),
                        Semantics(
                          label: _isFav
                              ? 'Remove from favorites'
                              : 'Add to favorites',
                          button: true,
                          child: Positioned(
                            top: 12,
                            right: 12,
                            child: GestureDetector(
                              onTap: () async {
                                await favoritesService.toggle(p.id);
                                setState(() => _isFav = !_isFav);
                                showToast(
                                    context,
                                    _isFav
                                        ? 'Added to favorites'
                                        : 'Removed from favorites');
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: cs.surface.withOpacity(0.8),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                    _isFav
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: _isFav
                                        ? cs.error
                                        : cs.onSurfaceVariant,
                                    size: 20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(AppTheme.containerMargin),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Price and transit
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Semantics(
                                label: 'Price ${p.price}',
                                child: Text(p.price,
                                    style: AppTextStyle.headlineLgMobile
                                        .copyWith(color: cs.primary)),
                              ),
                              if (p.transitScore > 0)
                                Semantics(
                                  label: 'Transit score ${p.transitScore}',
                                  child: Row(children: [
                                    Icon(Icons.directions_walk,
                                        size: 16, color: cs.onSurfaceVariant),
                                    SizedBox(width: 4),
                                    Text('${p.transitScore}',
                                        style: AppTextStyle.labelCaps),
                                  ]),
                                ),
                            ]),
                        SizedBox(height: 4),
                        Semantics(
                          label: 'Address: ${p.address}',
                          child: Text(p.address,
                              style: AppTextStyle.bodyMd
                                  .copyWith(color: cs.onSurfaceVariant)),
                        ),
                        SizedBox(height: AppTheme.spacingMd),

                        // Action buttons
                        Semantics(
                          label: 'Schedule a tour',
                          button: true,
                          child: Row(children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => showToast(
                                    context, 'Tour request sent!'),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: cs.secondary),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text('Schedule Tour',
                                      textAlign: TextAlign.center,
                                      style: AppTextStyle.headlineSm
                                          .copyWith(color: cs.secondary)),
                                ),
                              ),
                            ),
                            SizedBox(width: AppTheme.gutter),
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    Navigator.pushNamed(context, '/app-step1'),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    color: cs.primary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text('Apply Now',
                                      textAlign: TextAlign.center,
                                      style: AppTextStyle.headlineSm
                                          .copyWith(color: cs.onPrimary)),
                                ),
                              ),
                            ),
                          ]),
                        ),
                        SizedBox(height: AppTheme.spacingLg),

                        // Perk chips
                        Semantics(
                          label:
                              'Details: ${p.beds} beds, ${p.baths} baths, ${p.sqft} square feet${p.petsOk ? ', pets ok' : ''}',
                          child: Row(children: [
                            _perk('${p.beds}', 'BED', context),
                            SizedBox(width: 8),
                            _perk('${p.baths}', 'BATH', context),
                            SizedBox(width: 8),
                            _perk('${p.sqft}', 'SQFT', context),
                            if (p.petsOk) ...[
                              SizedBox(width: 8),
                              _perkIcon(Icons.pets, 'PETS OK', context),
                            ],
                          ]),
                        ),
                        SizedBox(height: AppTheme.spacingLg),

                        // Commute times section
                        if (commuteService.destinations.isNotEmpty) ...[
                          Semantics(
                            header: true,
                            child: Text('Commute Estimates',
                                style: AppTextStyle.headlineMd
                                    .copyWith(color: cs.primary)),
                          ),
                          SizedBox(height: AppTheme.spacingSm),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(AppTheme.spacingMd),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceContainerLowOf(context),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: cs.outlineVariant),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: commuteService
                                  .calculateCommuteTimes(p)
                                  .map((ct) => Padding(
                                        padding: const EdgeInsets.only(bottom: 6),
                                        child: Row(children: [
                                          Icon(Icons.directions_transit,
                                              size: 20, color: cs.secondary),
                                          SizedBox(width: 12),
                                          Text('${ct.key}: ',
                                              style: AppTextStyle.bodyMd),
                                          Text('${ct.value} min',
                                              style: AppTextStyle.bodyMd
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: cs.primary)),
                                        ]),
                                      ))
                                  .toList(),
                            ),
                          ),
                          SizedBox(height: AppTheme.spacingLg),
                        ],

                        // Insight
                        if (p.insight.isNotEmpty)
                          Semantics(
                            label: 'Insight: ${p.insight}',
                            child: Container(
                              padding: EdgeInsets.only(top: 12),
                              decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(color: cs.outlineVariant)),
                              ),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.lightbulb_outline,
                                        size: 20, color: cs.secondary),
                                    SizedBox(width: 8),
                                    Expanded(
                                        child: Text(p.insight,
                                            style: AppTextStyle.bodyMd
                                                .copyWith(color: cs.onSurface))),
                                  ]),
                            ),
                          ),
                        SizedBox(height: AppTheme.spacingMd),

                        // Add to Compare
                        Semantics(
                          label: 'Add this property to comparison',
                          button: true,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/compare');
                              showToast(context, 'Added to compare');
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: cs.outlineVariant,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add, color: cs.primary),
                                    SizedBox(width: 4),
                                    Text('Add to Compare',
                                        style: AppTextStyle.headlineSm
                                            .copyWith(color: cs.primary)),
                                  ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _perk(String val, String label, BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: AppTheme.surfaceContainerHighestOf(context)),
        ),
        child: Column(children: [
          Text(val,
              style: AppTextStyle.headlineSm.copyWith(color: cs.primary)),
          Text(label,
              style: AppTextStyle.labelCaps
                  .copyWith(color: cs.onSurfaceVariant)),
        ]),
      ),
    );
  }

  Widget _perkIcon(IconData icon, String label, BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: AppTheme.surfaceContainerHighestOf(context)),
        ),
        child: Column(children: [
          Icon(icon, size: 20, color: cs.primary),
          Text(label,
              style: AppTextStyle.labelCaps
                  .copyWith(color: cs.onSurfaceVariant)),
        ]),
      ),
    );
  }
}
