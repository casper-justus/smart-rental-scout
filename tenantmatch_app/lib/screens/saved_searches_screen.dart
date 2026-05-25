import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/app_dialog.dart';
import '../widgets/app_top_bar.dart';
import '../models/property.dart';
import '../main.dart';

class SavedSearchesScreen extends StatefulWidget {
  const SavedSearchesScreen({super.key});

  @override
  State<SavedSearchesScreen> createState() => _SavedSearchesScreenState();
}

class _SavedSearchesScreenState extends State<SavedSearchesScreen> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final savedProps = PropertyListing.sampleProperties.where((p) => favoritesService.isFavorite(p.id)).toList();

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(title: 'Saved Searches'),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(AppTheme.containerMargin),
                children: [
                  _searchCard('Downtown 2BR', '\$1,800 - \$2,400 · 2 bed', 3, context),
                  SizedBox(height: AppTheme.gutter),
                  _searchCard('Suburban Family Home', '\$2,500 - \$3,200 · 4 bed', 1, context),
                  SizedBox(height: AppTheme.gutter),
                  _searchCard('Studio < \$2k', 'Up to \$2,000 · Studio', 5, context),
                  SizedBox(height: AppTheme.spacingLg),
                  Text('Saved Properties', style: AppTextStyle.headlineMd.copyWith(color: cs.primary)),
                  SizedBox(height: AppTheme.spacingMd),
                  if (savedProps.isEmpty)
                    Container(
                      padding: EdgeInsets.all(24),
                      child: Column(children: [
                        Icon(Icons.favorite_border, size: 48, color: cs.onSurfaceVariant),
                        SizedBox(height: 8),
                        Text('No saved properties yet', style: AppTextStyle.bodyMd.copyWith(color: cs.onSurfaceVariant)),
                      ]),
                    )
                  else
                    ...savedProps.map((p) => Padding(
                      padding: EdgeInsets.only(bottom: AppTheme.gutter),
                      child: ListTile(
                        tileColor: cs.surface,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: cs.outlineVariant)),
                        title: Text(p.price, style: AppTextStyle.headlineSm.copyWith(color: cs.primary)),
                        subtitle: Text(p.address, style: AppTextStyle.bodyMd.copyWith(color: cs.onSurfaceVariant)),
                        trailing: GestureDetector(
                          onTap: () async { await favoritesService.toggle(p.id); setState(() {}); },
                          child: Icon(Icons.favorite, color: cs.error),
                        ),
                        onTap: () => Navigator.pushNamed(context, '/listing-details'),
                      ),
                    )),
                ],
              ),
            ),
            AppBottomNav(currentIndex: 2, onTap: (i) {
              if (i == 0) Navigator.pushNamed(context, '/home');
              if (i == 1) Navigator.pushNamed(context, '/search');
              if (i == 3) Navigator.pushNamed(context, '/profile');
            }),
          ],
        ),
      ),
    );
  }

  Widget _searchCard(String title, String details, int newCount, BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: AppTextStyle.headlineSm.copyWith(color: cs.onSurface)),
              SizedBox(height: 4),
              Text(details, style: AppTextStyle.bodyMd.copyWith(color: cs.onSurfaceVariant)),
            ]),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(12)),
            child: Text('$newCount new', style: TextStyle(color: cs.onPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
