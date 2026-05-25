import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_dialog.dart';
import '../widgets/app_top_bar.dart';
import '../models/property.dart';

class ComparePropertiesScreen extends StatefulWidget {
  const ComparePropertiesScreen({super.key});

  @override
  State<ComparePropertiesScreen> createState() => _ComparePropertiesScreenState();
}

class _ComparePropertiesScreenState extends State<ComparePropertiesScreen> {
  final List<PropertyListing> _columns = [
    PropertyListing.sampleProperties[0],
    PropertyListing.sampleProperties[1],
    PropertyListing.sampleProperties[2],
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              title: 'Compare',
              actions: [
                GestureDetector(
                  onTap: () => showAppAlert(context, 'Add Property', 'Navigate to search to add more properties to compare.'),
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      border: Border.all(color: cs.outlineVariant),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.add, size: 18, color: cs.primary),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(AppTheme.containerMargin),
                children: _columns.asMap().entries.map((e) {
                  final i = e.key;
                  final p = e.value;
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    margin: EdgeInsets.only(right: AppTheme.gutter),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () => setState(() => _columns.removeAt(i)),
                                child: Container(
                                  width: 28, height: 28,
                                  decoration: BoxDecoration(color: AppTheme.surfaceContainerOf(context), shape: BoxShape.circle),
                                  child: Icon(Icons.close, size: 16, color: cs.onSurfaceVariant),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
                          child: Column(children: [
                            Container(height: 120, color: AppTheme.surfaceContainerOf(context), child: Image.network(p.imageUrl, fit: BoxFit.cover, width: double.infinity,
                              errorBuilder: (_, __, ___) => Icon(Icons.home, color: cs.onSurfaceVariant))),
                            SizedBox(height: 12),
                            Text(p.price, style: AppTextStyle.headlineMd.copyWith(color: cs.primary)),
                            Text(p.address, style: AppTextStyle.bodyMd.copyWith(color: cs.onSurfaceVariant), maxLines: 2),
                            SizedBox(height: 12),
                            _compareRow('Bedrooms', '${p.beds}', context),
                            _compareRow('Bathrooms', '${p.baths}', context),
                            _compareRow('Square Ft', '${p.sqft}', context),
                            _compareRow('Walk Score', '${p.transitScore}', context),
                            _compareRow('Pets', p.petsOk ? 'Yes' : 'No', context),
                            SizedBox(height: 12),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(context, '/listing-details'),
                              child: Container(
                                width: double.infinity, padding: EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(8)),
                                child: Text('View Details', textAlign: TextAlign.center, style: AppTextStyle.headlineSm.copyWith(color: cs.onPrimary)),
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _compareRow(String label, String value, BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: AppTextStyle.bodyMd.copyWith(color: cs.onSurfaceVariant)),
        Text(value, style: AppTextStyle.bodyMd.copyWith(fontWeight: FontWeight.w600)),
      ]),
    );
  }
}
