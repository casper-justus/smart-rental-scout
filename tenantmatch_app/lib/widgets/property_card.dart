import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/property.dart';
import '../main.dart';

class PropertyCard extends StatelessWidget {
  final PropertyListing property;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteTap;
  final bool showTenantScore;
  final bool compact;

  const PropertyCard({
    super.key,
    required this.property,
    required this.isFavorite,
    required this.onTap,
    this.onFavoriteTap,
    this.showTenantScore = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Property: ${property.price}, ${property.address}. ${property.beds} bedrooms, ${property.baths} bathrooms, ${property.sqft} square feet${property.petsOk ? ', pets allowed' : ''}',
      child: GestureDetector(
        onTap: onTap,
        onLongPress: () {
          // Haptic feedback for long press
          HapticFeedback.mediumImpact();
          if (onFavoriteTap != null) onFavoriteTap!();
        },
        child: Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF1A2B4C).withOpacity(0.04),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section
              Hero(
                tag: 'property_img_${property.id}',
                child: Stack(
                  children: [
                    Semantics(
                      label: 'Property image',
                      excludeSemantics: true,
                      child: Container(
                        height: compact ? 120 : 160,
                        width: double.infinity,
                        color: AppTheme.surfaceContainerOf(context),
                        child: Image.network(
                          property.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.home_outlined,
                            size: 48,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    if (property.isHot || property.isGreatValue)
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: cs.surface,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: cs.outlineVariant),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                property.isHot ? Icons.local_fire_department : Icons.star,
                                size: 14,
                                color: property.chipColor,
                              ),
                              SizedBox(width: 4),
                              Text(
                                property.chipLabel,
                                style: AppTextStyle.labelCaps.copyWith(
                                  color: property.chipColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (showTenantScore)
                      Semantics(
                        label: 'Tenant score: ${property.tenantScore} out of 100',
                        child: Positioned(
                          bottom: 12,
                          left: 12,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: cs.secondaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.analytics_outlined,
                                    size: 16, color: cs.onSecondaryContainer),
                                SizedBox(width: 4),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('TENANT SCORE',
                                        style: AppTextStyle.labelCaps.copyWith(
                                          color: cs.onSecondaryContainer,
                                          fontSize: 10,
                                        )),
                                    Text('${property.tenantScore}/100',
                                        style: AppTextStyle.headlineSm.copyWith(
                                          color: cs.onSecondaryContainer,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    Semantics(
                      label: isFavorite ? 'Remove from favorites' : 'Add to favorites',
                      button: true,
                      child: Positioned(
                        top: 12,
                        right: 12,
                        child: GestureDetector(
                          onTap: onFavoriteTap,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: cs.surface.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite
                                  ? cs.error
                                  : cs.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Details section
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Price and transit score
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          property.price,
                          style: AppTextStyle.headlineMd
                              .copyWith(color: cs.primary),
                        ),
                        if (property.transitScore > 0)
                          Row(
                            children: [
                              Icon(Icons.directions_walk,
                                  size: 16, color: cs.onSurfaceVariant),
                              SizedBox(width: 2),
                              Text('${property.transitScore}',
                                  style: AppTextStyle.labelCaps),
                            ],
                          ),
                      ],
                    ),
                    SizedBox(height: 4),
                    // Address
                    Text(
                      property.address,
                      style: AppTextStyle.bodyMd
                          .copyWith(color: cs.onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: compact ? 6 : 12),
                    // Perk chips
                    Row(
                      children: [
                        _buildPerkChip('${property.beds}', 'BED', context),
                        SizedBox(width: 8),
                        _buildPerkChip('${property.baths}', 'BATH', context),
                        SizedBox(width: 8),
                        _buildPerkChip('${property.sqft}', 'SQFT', context),
                        if (property.petsOk) ...[
                          SizedBox(width: 8),
                          _buildPerkChip(null, 'PETS OK', context,
                              icon: Icons.pets),
                        ],
                      ],
                    ),
                    // Commute times
                    if (commuteService.destinations.isNotEmpty) ...[
                      SizedBox(height: 10),
                      _buildCommuteTimes(context),
                    ],
                    // Insight
                    if (property.insight.isNotEmpty && !compact) ...[
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.only(top: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: cs.outlineVariant),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.lightbulb_outline,
                                size: 20, color: cs.secondary),
                            SizedBox(width: 8),
                            Expanded(
                              child: Semantics(
                                label: 'Insight: ${property.insight}',
                                child: Text(
                                  property.insight,
                                  style: AppTextStyle.bodyMd
                                      .copyWith(color: cs.onSurface),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommuteTimes(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final times = commuteService.calculateCommuteTimes(property);
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowOf(context),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: times.map((t) => Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.directions_transit, size: 14, color: cs.secondary),
              SizedBox(width: 4),
              Text('${t.key}: ',
                  style: AppTextStyle.bodyMd.copyWith(fontSize: 12)),
              Text('${t.value} min',
                  style: AppTextStyle.bodyMd.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: cs.primary,
                  )),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildPerkChip(String? value, String label, BuildContext context,
      {IconData? icon}) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: AppTheme.surfaceContainerHighestOf(context)),
      ),
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: cs.primary),
                SizedBox(width: 2),
                Text(label,
                    style: AppTextStyle.labelCaps
                        .copyWith(color: cs.onSurfaceVariant)),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(value ?? '',
                    style: AppTextStyle.headlineSm
                        .copyWith(color: cs.primary)),
                Text(label,
                    style: AppTextStyle.labelCaps
                        .copyWith(color: cs.onSurfaceVariant)),
              ],
            ),
    );
  }
}
