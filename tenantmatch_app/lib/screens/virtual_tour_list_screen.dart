import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/property_card.dart';
import '../models/property.dart';
import '../main.dart';

class VirtualTourListScreen extends StatelessWidget {
  const VirtualTourListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tourProps = PropertyListing.sampleProperties
        .where((p) => p.hasVirtualTour)
        .toList();

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            const AppTopBar(showBack: true, title: 'Virtual Tours'),
            if (tourProps.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.view_in_ar, size: 64, color: cs.onSurfaceVariant),
                      const SizedBox(height: 16),
                      Text('No virtual tours available',
                          style: AppTextStyle.headlineMd.copyWith(color: cs.onSurfaceVariant)),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(AppTheme.containerMargin),
                  physics: const BouncingScrollPhysics(),
                  itemCount: tourProps.length,
                  itemBuilder: (context, index) {
                    final p = tourProps[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: AppTheme.gutter),
                      child: PropertyCard(
                        property: p,
                        isFavorite: favoritesService.isFavorite(p.id),
                        onTap: () => Navigator.pushNamed(
                            context, '/virtual-tour', arguments: p.id),
                        onFavoriteTap: () => favoritesService.toggle(p.id),
                        showTenantScore: p.tenantScore > 85,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
