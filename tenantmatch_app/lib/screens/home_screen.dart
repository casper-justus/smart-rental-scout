import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/property_card.dart';
import '../widgets/bottom_nav.dart';
import '../models/property.dart';
import '../main.dart';
import '../widgets/app_dialog.dart';
import '../widgets/app_top_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: AppTheme.containerMargin),
                children: [
                  AppTopBar(showBack: false),
                  SizedBox(height: AppTheme.spacingMd),
                  Text(
                    'Good morning, Jane.\nReady to find your match?',
                    style: AppTextStyle.headlineLgMobile.copyWith(color: cs.primary),
                  ),
                  SizedBox(height: AppTheme.spacingMd),
                  _buildSearchBar(context),
                  SizedBox(height: AppTheme.spacingLg),
                  _buildQuickActions(context),
                  SizedBox(height: AppTheme.spacingLg),
                  _buildTopMatches(context),
                  SizedBox(height: AppTheme.spacingLg),
                  _buildMarketInsights(context),
                  SizedBox(height: AppTheme.spacingLg),
                ],
              ),
            ),
            AppBottomNav(
              currentIndex: 0,
              onTap: (i) {
                if (i == 1) Navigator.pushNamed(context, '/search');
                if (i == 2) Navigator.pushNamed(context, '/saved');
                if (i == 3) Navigator.pushNamed(context, '/profile');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingMd, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.search, color: cs.onSurfaceVariant),
          SizedBox(width: AppTheme.spacingSm),
          Expanded(
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration.collapsed(
                hintText: 'Search neighborhoods, ZIP codes...',
                hintStyle: AppTextStyle.bodyMd.copyWith(color: cs.onSurfaceVariant),
              ),
              onSubmitted: (_) => Navigator.pushNamed(context, '/search'),
            ),
          ),
          SizedBox(width: AppTheme.spacingSm),
          GestureDetector(
            onTap: () => showAppAlert(context, 'Filters', 'Price Range: \$500 - \$5,000\nBedrooms: 1-4\nProperty Type: Apartment, House, Condo\nAmenities: Parking, Gym, Laundry, Pets'),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.tune, size: 16, color: cs.onPrimary),
                  SizedBox(width: 4),
                  Text('Filters', style: AppTextStyle.bodyMd.copyWith(color: cs.onPrimary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: AppTextStyle.headlineMd.copyWith(color: cs.primary)),
        SizedBox(height: AppTheme.spacingMd),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _actionCard(Icons.directions_transit, 'Commute Hub', 'Check your routes', context, () => Navigator.pushNamed(context, '/commute-hub')),
              SizedBox(width: AppTheme.gutter),
              _actionCard(Icons.bookmark, 'Saved Searches', '2 new listings', context, () => Navigator.pushNamed(context, '/saved')),
              SizedBox(width: AppTheme.gutter),
              _actionCard(Icons.view_in_ar, 'Virtual Tours', 'Explore remotely', context, () => Navigator.pushNamed(context, '/virtual-tour')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _actionCard(IconData icon, String title, String subtitle, BuildContext context, VoidCallback onTap) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: EdgeInsets.all(AppTheme.spacingMd),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant),
          boxShadow: [
            BoxShadow(color: Color(0xFF1A2B4C).withOpacity(0.04), blurRadius: 12, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerLowOf(context),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: cs.primary),
            ),
            Spacer(),
            Text(title, style: AppTextStyle.headlineSm.copyWith(color: cs.onSurface)),
            SizedBox(height: 4),
            Text(subtitle, style: AppTextStyle.bodyMd.copyWith(color: cs.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopMatches(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final p = PropertyListing.sampleProperties[0];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.verified, size: 20, color: cs.secondary),
                SizedBox(width: 8),
                Text('Your Top Matches', style: AppTextStyle.headlineMd.copyWith(color: cs.primary)),
              ],
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/search'),
              child: Text('See all', style: AppTextStyle.headlineSm.copyWith(color: cs.primary)),
            ),
          ],
        ),
        SizedBox(height: AppTheme.spacingMd),
        PropertyCard(
          property: p,
          isFavorite: favoritesService.isFavorite(p.id),
          onTap: () => Navigator.pushNamed(context, '/listing-details'),
          onFavoriteTap: () async {
            await favoritesService.toggle(p.id);
            setState(() {});
          },
          showTenantScore: true,
        ),
      ],
    );
  }

  Widget _buildMarketInsights(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.trending_up, size: 20, color: cs.secondary),
            SizedBox(width: 8),
            Text('Market Insights', style: AppTextStyle.headlineMd.copyWith(color: cs.primary)),
          ],
        ),
        SizedBox(height: AppTheme.spacingMd),
        GestureDetector(
          onTap: () => showAppAlert(context, 'Market Insight', 'Rent trends in Downtown: Average rent for 2 beds is down 4.5% compared to last month. Good time to negotiate.'),
          child: Container(
            padding: EdgeInsets.all(AppTheme.spacingMd),
            decoration: BoxDecoration(
              color: cs.surface,
              border: Border(left: BorderSide(color: cs.secondary, width: 2)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('RENT TRENDS IN DOWNTOWN', style: AppTextStyle.labelCaps.copyWith(color: cs.onSurfaceVariant)),
                SizedBox(height: 4),
                Text('-\$150', style: AppTextStyle.headlineLgMobile.copyWith(color: cs.primary)),
                SizedBox(height: 8),
                Text('Average rent for 2 beds is down 4.5% compared to last month. Good time to negotiate.', style: AppTextStyle.bodyMd.copyWith(color: cs.onSurfaceVariant)),
                SizedBox(height: 12),
                Row(
                  children: [20, 32, 28, 18, 14, 10].map((h) => Expanded(
                    child: Container(
                      height: 40, margin: EdgeInsets.symmetric(horizontal: 1),
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: h * 1.2, width: double.infinity,
                        decoration: BoxDecoration(
                          color: h == 10 ? cs.secondary : cs.outlineVariant,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
                        ),
                      ),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppTheme.gutter),
        GestureDetector(
          onTap: () => showAppAlert(context, 'New Listings', '42 new listings hit the market this week in your target area.'),
          child: Container(
            padding: EdgeInsets.all(AppTheme.spacingMd),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerLowOf(context),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(Icons.inventory_2, color: cs.primary),
                ),
                SizedBox(width: AppTheme.gutter),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('NEW LISTINGS', style: AppTextStyle.labelCaps.copyWith(color: cs.onSurfaceVariant)),
                    Text('42 this week', style: AppTextStyle.headlineMd.copyWith(color: cs.primary)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
