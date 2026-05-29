import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';
import '../models/property.dart';
import '../main.dart';

class PropertyCard extends StatefulWidget {
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
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  final _pageCtrl = PageController();
  var _currentPage = 0;

  @override
  void didUpdateWidget(PropertyCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.property.id != widget.property.id) {
      _currentPage = 0;
    }
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Property: ${widget.property.price}, ${widget.property.address}. ${widget.property.beds} bedrooms, ${widget.property.baths} bathrooms, ${widget.property.sqft} square feet${widget.property.petsOk ? ', pets allowed' : ''}',
      child: GestureDetector(
        onTap: widget.onTap,
        onLongPress: () {
          HapticFeedback.mediumImpact();
          if (widget.onFavoriteTap != null) widget.onFavoriteTap!();
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
            mainAxisSize: widget.compact ? MainAxisSize.min : MainAxisSize.max,
            children: [
              // Image section
              _buildImageSection(context),
              // Name/Address space below image
              _buildNameSection(context),
              // Details section — hidden in compact mode to prevent overflow
              if (!widget.compact) _buildDetailsSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final imgHeight = widget.compact ? 100 : 160;
    final decodeWidth = widget.compact ? 240 : 320;
    final decodeHeight = widget.compact ? 150 : 200;
    final imgs = widget.property.images;

    return RepaintBoundary(
      child: Stack(
        children: [
          SizedBox(
            height: imgHeight.toDouble(),
            child: PageView.builder(
              controller: _pageCtrl,
              itemCount: imgs.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (context, index) {
                return Hero(
                  tag: index == 0 ? 'property_img_${widget.property.id}' : 'property_img_${widget.property.id}_$index',
                  child: Container(
                    color: AppTheme.surfaceContainerOf(context),
                    child: CachedNetworkImage(
                      imageUrl: imgs[index],
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
                );
              },
            ),
          ),
          // Carousel dots
          Positioned(
            bottom: 6,
            left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(imgs.length, (i) {
                return Container(
                  width: 16,
                  height: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(i == _currentPage ? 0.9 : 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
          ),
          // Hot / Great Value badge (top-right)
          if (widget.property.isHot || widget.property.isGreatValue)
            Positioned(
              top: 12,
              right: 52,
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
                      widget.property.isHot ? Icons.local_fire_department : Icons.star,
                      size: 14,
                      color: widget.property.chipColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.property.chipLabel,
                      style: AppTextStyle.labelCaps.copyWith(
                        color: widget.property.chipColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // Tenant score (bottom-right on cards)
          if (widget.showTenantScore)
            Positioned(
              bottom: 12,
              right: 12,
              child: Semantics(
                label: 'Tenant score: ${widget.property.tenantScore} out of 100',
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: cs.secondaryContainer.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.analytics_outlined,
                          size: 14, color: cs.onSecondaryContainer),
                      const SizedBox(width: 4),
                      Text('${widget.property.tenantScore}',
                          style: AppTextStyle.headlineSm.copyWith(
                            color: cs.onSecondaryContainer,
                            fontSize: 12,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          // Favorite button (top-right)
          Positioned(
            top: 12,
            right: 12,
            child: Semantics(
              label: widget.isFavorite ? 'Remove from favorites' : 'Add to favorites',
              button: true,
              child: GestureDetector(
                onTap: widget.onFavoriteTap,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: cs.surface.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: widget.isFavorite ? cs.error : cs.onSurfaceVariant,
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

  Widget _buildNameSection(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: cs.surface,
      child: Text(
        widget.property.address,
        style: AppTextStyle.bodyMd.copyWith(
          color: cs.onSurface,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.property.price,
                style: AppTextStyle.headlineMd.copyWith(color: cs.primary),
              ),
              if (widget.property.transitScore > 0)
                Row(
                  children: [
                    Icon(Icons.directions_walk,
                        size: 16, color: cs.onSurfaceVariant),
                    const SizedBox(width: 2),
                    Text('${widget.property.transitScore}',
                        style: AppTextStyle.labelCaps),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildPerkChip('${widget.property.beds}', 'BED', context),
              const SizedBox(width: 8),
              _buildPerkChip('${widget.property.baths}', 'BATH', context),
              const SizedBox(width: 8),
              _buildPerkChip('${widget.property.sqft}', 'SQFT', context),
              if (widget.property.petsOk) ...[
                const SizedBox(width: 8),
                _buildPerkChip(null, 'PETS OK', context, icon: Icons.pets),
              ],
            ],
          ),
          if (commuteService.destinations.isNotEmpty) ...[
            const SizedBox(height: 10),
            _buildCommuteTimes(context),
          ],
          if (widget.property.insight.isNotEmpty) ...[
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
                  Icon(Icons.lightbulb_outline, size: 20, color: cs.secondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Semantics(
                      label: 'Insight: ${widget.property.insight}',
                      child: Text(
                        widget.property.insight,
                        style: AppTextStyle.bodyMd.copyWith(color: cs.onSurface),
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
    final times = commuteService.calculateCommuteTimes(widget.property);
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
              Text('${t.key}: ', style: AppTextStyle.bodyMd.copyWith(fontSize: 12)),
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

  Widget _buildPerkChip(String? value, String label, BuildContext context, {IconData? icon}) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.surfaceContainerHighestOf(context)),
      ),
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: cs.primary),
                const SizedBox(width: 2),
                Text(label, style: AppTextStyle.labelCaps.copyWith(color: cs.onSurfaceVariant)),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(value ?? '', style: AppTextStyle.headlineSm.copyWith(color: cs.primary)),
                Text(label, style: AppTextStyle.labelCaps.copyWith(color: cs.onSurfaceVariant)),
              ],
            ),
    );
  }
}
