import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_dialog.dart';
import '../widgets/app_top_bar.dart';
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
                  Stack(
                    children: [
                      Container(
                        height: 250,
                        width: double.infinity,
                        color: AppTheme.surfaceContainerOf(context),
                        child: Image.network(p.imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Icon(Icons.home, size: 64, color: cs.onSurfaceVariant)),
                      ),
                      Positioned(top: 12, left: 12,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: cs.surface, borderRadius: BorderRadius.circular(999)),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Icon(Icons.local_fire_department, size: 14, color: cs.secondary),
                            SizedBox(width: 4),
                            Text('HOT', style: AppTextStyle.labelCaps),
                          ]),
                        ),
                      ),
                      Positioned(bottom: 12, left: 12,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(color: cs.secondaryContainer, borderRadius: BorderRadius.circular(8)),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('TENANT SCORE', style: AppTextStyle.labelCaps.copyWith(color: cs.onSecondaryContainer, fontSize: 10)),
                            Text('94/100', style: AppTextStyle.headlineSm.copyWith(color: cs.onSecondaryContainer)),
                          ]),
                        ),
                      ),
                      Positioned(top: 12, right: 12,
                        child: GestureDetector(
                          onTap: () async { await favoritesService.toggle(p.id); setState(() { _isFav = !_isFav; }); },
                          child: Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(color: cs.surface.withOpacity(0.8), shape: BoxShape.circle),
                            child: Icon(_isFav ? Icons.favorite : Icons.favorite_border, color: _isFav ? cs.error : cs.onSurfaceVariant, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(AppTheme.containerMargin),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(p.price, style: AppTextStyle.headlineLgMobile.copyWith(color: cs.primary)),
                            Row(children: [
                              Icon(Icons.directions_walk, size: 16, color: cs.onSurfaceVariant),
                              SizedBox(width: 4),
                              Text('${p.transitScore}', style: AppTextStyle.labelCaps),
                            ]),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(p.address, style: AppTextStyle.bodyMd.copyWith(color: cs.onSurfaceVariant)),
                        SizedBox(height: AppTheme.spacingMd),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => showAppAlert(context, 'Tour Scheduled!', 'Your tour request has been received. The property manager will confirm your appointment within 24 hours.'),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: cs.secondary),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text('Schedule Tour', textAlign: TextAlign.center, style: AppTextStyle.headlineSm.copyWith(color: cs.secondary)),
                                ),
                              ),
                            ),
                            SizedBox(width: AppTheme.gutter),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => Navigator.pushNamed(context, '/app-step1'),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    color: cs.primary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text('Apply Now', textAlign: TextAlign.center, style: AppTextStyle.headlineSm.copyWith(color: cs.onPrimary)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppTheme.spacingLg),
                        Row(
                          children: [
                            _perk('${p.beds}', 'BED', context),
                            SizedBox(width: 8),
                            _perk('${p.baths}', 'BATH', context),
                            SizedBox(width: 8),
                            _perk('${p.sqft}', 'SQFT', context),
                            if (p.petsOk) ...[
                              SizedBox(width: 8),
                              _perkIcon(Icons.pets, 'PETS OK', context),
                            ],
                          ],
                        ),
                        SizedBox(height: AppTheme.spacingLg),
                        Container(
                          padding: EdgeInsets.only(top: 12),
                          decoration: BoxDecoration(border: Border(top: BorderSide(color: cs.outlineVariant))),
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Icon(Icons.lightbulb_outline, size: 20, color: cs.secondary),
                            SizedBox(width: 8),
                            Expanded(child: Text(p.insight, style: AppTextStyle.bodyMd.copyWith(color: cs.onSurface))),
                          ]),
                        ),
                        SizedBox(height: AppTheme.spacingMd),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/compare'),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              border: Border.all(color: cs.outlineVariant, style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Icon(Icons.add, color: cs.primary),
                              SizedBox(width: 4),
                              Text('Add to Compare', style: AppTextStyle.headlineSm.copyWith(color: cs.primary)),
                            ]),
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
          border: Border.all(color: AppTheme.surfaceContainerHighestOf(context)),
        ),
        child: Column(children: [
          Text(val, style: AppTextStyle.headlineSm.copyWith(color: cs.primary)),
          Text(label, style: AppTextStyle.labelCaps.copyWith(color: cs.onSurfaceVariant)),
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
          border: Border.all(color: AppTheme.surfaceContainerHighestOf(context)),
        ),
        child: Column(children: [
          Icon(icon, size: 20, color: cs.primary),
          Text(label, style: AppTextStyle.labelCaps.copyWith(color: cs.onSurfaceVariant)),
        ]),
      ),
    );
  }
}
