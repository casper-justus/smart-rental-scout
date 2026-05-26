import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
                color: const Color(0xFF1A2B4C).withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
            children: [
              // Image section
              _buildImageSection(context),
              // Details section — hidden in compact mode to prevent overflow
              if (!compact) _buildDetailsSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final imgHeight = compact ? 120 : 160;
    // Decode images at reasonable sizes for performance
    final decodeWidth = compact ? 300 : 400;
    final decodeHeight = compact ? 180 : 240;

    return RepaintBoundary(
      child: Hero(
      tag: 'property_img_${property.id}',
      child: Stack(
        children: [
          Semantics(
            label: 'Property image',
            excludeSemantics: true,
            child: Container(
              height: imgHeight.toDouble(),
              width: double.infinity,
              color: AppTheme.surfaceContainerOf(context),
              child: CachedNetworkImage(
                imageUrl: property.imageUrl,
                fit: BoxFit.cover,
                memCacheWidth: decodeWidth,
                memCacheHeight: decodeHeight,
                placeholder: (_, __) => Container(
                  color: AppTheme.surfaceContainerOf(context),
                ),
                errorWidget: (_, __, ___) => Icon(
                  Icons.home_outlined,
                  size: 48,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
          ),
          // Gradient overlay at bottom for name label
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                ),
              ),
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
              alignment: Alignment.bottomLeft,
              child: Text(
                property.address,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // Hot / Great Value badge (top-left)
          if (property.isHot || property.isGreatValue)
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    const SizedBox(width: 4),
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
          // Tenant score (bottom-right)
          if (showTenantScore)
            Semantics(
              label: 'Tenant score: ${property.tenantScore} out of 100',
              child: Positioned(
                bottom: 52,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: cs.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.analytics_outlined,
                          size: 16, color: cs.onSecondaryContainer),
                      const SizedBox(width: 4),
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
          // Favorite button (top-right)
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
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(12),
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
                    const SizedBox(width: 2),
                    Text('${property.transitScore}',
                        style: AppTextStyle.labelCaps),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 4),
          // Address
          Text(
            property.address,
            style: AppTextStyle.bodyMd
                .copyWith(color: cs.onSurfaceVariant),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          // Perk chips
          Row(
            children: [
              _buildPerkChip('${property.beds}', 'BED', context),
              const SizedBox(width: 8),
              _buildPerkChip('${property.baths}', 'BATH', context),
              const SizedBox(width: 8),
              _buildPerkChip('${property.sqft}', 'SQFT', context),
              if (property.petsOk) ...[
                const SizedBox(width: 8),
                _buildPerkChip(null, 'PETS OK', context,
                    icon: Icons.pets),
              ],
            ],
          ),
          // Commute times
          if (commuteService.destinations.isNotEmpty) ...[
            const SizedBox(height: 10),
            _buildCommuteTimes(context),
          ],
          // Insight
          if (property.insight.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.only(top: 12),
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
                  const SizedBox(width: 8),
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
    );
  }

  Widget _buildCommuteTimes(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final times = commuteService.calculateCommuteTimes(property);
    return Container(
      padding: const EdgeInsets.all(8),
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
              const SizedBox(width: 4),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
                const SizedBox(width: 2),
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
