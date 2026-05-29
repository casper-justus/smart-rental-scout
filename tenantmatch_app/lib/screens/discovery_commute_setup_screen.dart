import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_dialog.dart';

class DiscoveryCommuteSetupScreen extends StatefulWidget {
  const DiscoveryCommuteSetupScreen({super.key});

  @override
  State<DiscoveryCommuteSetupScreen> createState() => _DiscoveryCommuteSetupScreenState();
}

class _DiscoveryCommuteSetupScreenState extends State<DiscoveryCommuteSetupScreen> {
  final _locCtrl = TextEditingController();
  final _destCtrl = TextEditingController();
  final Set<String> _hubs = {};
  final Set<String> _perks = {};
  final List<String> _customDests = [];
  final _hubOptions = ['Work', 'School', 'Gym', 'Parents'];
  final _perkOptions = ['Pet Friendly', 'Near Metro', 'Gym', 'High-speed Internet', 'In-unit Laundry'];

  @override
  void dispose() {
    _locCtrl.dispose();
    _destCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [cs.primary.withOpacity(0.8), cs.secondary.withOpacity(0.6)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
              ),
              child: Center(child: Icon(Icons.pin_drop, size: 64, color: Colors.white.withOpacity(0.3))),
            ),
            Padding(
              padding: EdgeInsets.all(AppTheme.containerMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Find your perfect match', style: AppTextStyle.headlineLgMobile.copyWith(color: cs.primary)),
                  SizedBox(height: 4),
                  Text('Tell us what makes a house a home for you.', style: AppTextStyle.bodyLg.copyWith(color: cs.onSurfaceVariant)),
                  SizedBox(height: AppTheme.spacingLg),
                  Text('Target Location', style: AppTextStyle.labelCaps.copyWith(color: cs.onSurfaceVariant)),
                  SizedBox(height: 8),
                  _inputField(_locCtrl, 'City, Neighborhood, or Zip code', Icons.search, context),
                  SizedBox(height: AppTheme.spacingLg),
                  Row(children: [
                    Text('Commute Hub', style: AppTextStyle.headlineSm.copyWith(color: cs.onSurface)),
                    SizedBox(width: 4),
                    Icon(Icons.route, size: 16, color: cs.onSurfaceVariant),
                  ]),
                  SizedBox(height: 8),
                  Text('Add frequent destinations to calculate your commute.', style: AppTextStyle.bodyMd.copyWith(color: cs.onSurfaceVariant)),
                  SizedBox(height: AppTheme.spacingSm),
                  Wrap(
                    spacing: 8, runSpacing: 6,
                    children: _hubOptions.map((h) {
                      final sel = _hubs.contains(h);
                      return GestureDetector(
                        onTap: () => setState(() { sel ? _hubs.remove(h) : _hubs.add(h); }),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: sel ? cs.secondaryContainer : AppTheme.surfaceContainerHighOf(context),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(h, style: AppTextStyle.bodyMd.copyWith(color: sel ? cs.onSecondaryContainer : cs.primary)),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: AppTheme.spacingSm),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: cs.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: cs.outlineVariant),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          child: Row(children: [
                            Icon(Icons.add_location, color: cs.outline),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _destCtrl,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  hintText: 'Add a destination...',
                                  hintStyle: AppTextStyle.bodyMd.copyWith(color: cs.onSurfaceVariant),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: _addDestination,
                        child: Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(6)),
                          child: Icon(Icons.add, color: cs.onPrimary, size: 18),
                        ),
                      ),
                    ],
                  ),
                  if (_customDests.isNotEmpty) ...[
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8, runSpacing: 6,
                      children: _customDests.map((d) => Chip(
                        label: Text(d, style: AppTextStyle.bodyMd),
                        deleteIcon: Icon(Icons.close, size: 16),
                        backgroundColor: cs.primary,
                        labelStyle: TextStyle(color: cs.onPrimary),
                        deleteIconColor: cs.onPrimary,
                        onDeleted: () => setState(() => _customDests.remove(d)),
                      )).toList(),
                    ),
                  ],
                  SizedBox(height: AppTheme.spacingLg),
                  Row(children: [
                    Text('Must-have perks', style: AppTextStyle.headlineSm.copyWith(color: cs.onSurface)),
                    SizedBox(width: 4),
                    Icon(Icons.stars, size: 16, color: cs.onSurfaceVariant),
                  ]),
                  SizedBox(height: AppTheme.spacingSm),
                  Wrap(
                    spacing: AppTheme.gutter, runSpacing: AppTheme.gutter,
                    children: _perkOptions.map((perk) {
                      final sel = _perks.contains(perk);
                      return GestureDetector(
                        onTap: () => setState(() { sel ? _perks.remove(perk) : _perks.add(perk); }),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: sel ? cs.secondaryContainer : AppTheme.surfaceContainerOf(context),
                            borderRadius: BorderRadius.circular(8),
                            border: sel ? Border.all(color: Colors.transparent) : Border.all(color: Colors.transparent),
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Icon(sel ? Icons.check_circle : Icons.add_circle_outline, size: 20, color: sel ? cs.onSecondaryContainer : cs.primary),
                            SizedBox(width: 8),
                            Text(perk, style: AppTextStyle.bodyMd.copyWith(color: sel ? cs.onSecondaryContainer : cs.primary, fontWeight: FontWeight.w500)),
                          ]),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: AppTheme.spacingLg),
                  GestureDetector(
                    onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => true),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(12)),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text('Get Started', style: AppTextStyle.headlineSm.copyWith(color: cs.onPrimary)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: cs.onPrimary),
                      ]),
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

  void _addDestination() {
    final t = _destCtrl.text.trim();
    if (t.isNotEmpty) {
      setState(() { _customDests.add(t); _destCtrl.clear(); });
    } else {
      showAppAlert(context, 'Missing Info', 'Please enter a destination name first.');
    }
  }

  Widget _inputField(TextEditingController ctrl, String hint, IconData icon, BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cs.outlineVariant),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(children: [
        Icon(icon, color: cs.outline),
        SizedBox(width: 8),
        Expanded(child: TextField(
          controller: ctrl,
          decoration: InputDecoration(
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
            hintText: hint,
            hintStyle: AppTextStyle.bodyMd.copyWith(color: cs.onSurfaceVariant),
          ),
        )),
      ]),
    );
  }
}
