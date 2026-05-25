import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_dialog.dart';
import '../widgets/app_top_bar.dart';

class CommuteHubSettingsScreen extends StatefulWidget {
  const CommuteHubSettingsScreen({super.key});

  @override
  State<CommuteHubSettingsScreen> createState() => _CommuteHubSettingsScreenState();
}

class _CommuteHubSettingsScreenState extends State<CommuteHubSettingsScreen> {
  final _destCtrl = TextEditingController();
  final List<String> _destinations = ['Work - 1200 Broadway, Suite 400', 'Gym - 450 Fitness Ave', 'School - 850 College Blvd'];

  @override
  void dispose() {
    _destCtrl.dispose();
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
            AppTopBar(title: 'Commute Hub'),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(AppTheme.containerMargin),
                children: [
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: cs.secondaryContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: cs.secondaryContainer.withOpacity(0.5)),
                    ),
                    child: Center(child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.map, size: 48, color: cs.secondary.withOpacity(0.5)),
                        SizedBox(height: 8),
                        Text('Map', style: TextStyle(color: cs.secondary.withOpacity(0.7))),
                      ],
                    )),
                  ),
                  SizedBox(height: AppTheme.spacingLg),
                  Text('Saved Destinations', style: AppTextStyle.headlineSm.copyWith(color: cs.onSurface)),
                  SizedBox(height: AppTheme.spacingSm),
                  ..._destinations.asMap().entries.map((e) => _destCard(e.key, e.value, context)),
                  SizedBox(height: AppTheme.spacingLg),
                  Text('Add New Destination', style: AppTextStyle.headlineSm.copyWith(color: cs.onSurface)),
                  SizedBox(height: AppTheme.spacingSm),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(color: cs.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: cs.outlineVariant)),
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Row(children: [
                            Icon(Icons.location_on_outlined, color: cs.onSurfaceVariant),
                            SizedBox(width: 8),
                            Expanded(child: TextField(
                              controller: _destCtrl,
                              decoration: InputDecoration.collapsed(hintText: 'Enter address or place', hintStyle: AppTextStyle.bodyMd.copyWith(color: cs.onSurfaceVariant)),
                            )),
                          ]),
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          if (_destCtrl.text.trim().isNotEmpty) {
                            setState(() { _destinations.add(_destCtrl.text.trim()); _destCtrl.clear(); });
                          }
                        },
                        child: Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(10)),
                          child: Icon(Icons.add, color: cs.onPrimary),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppTheme.spacingLg),
                  GestureDetector(
                    onTap: () => showAppAlert(context, 'Commute Times', 'Calculating commute times for your saved destinations...'),
                    child: Container(
                      width: double.infinity, padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(12)),
                      child: Text('Check Commute Times', textAlign: TextAlign.center, style: AppTextStyle.headlineSm.copyWith(color: cs.onPrimary)),
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

  Widget _destCard(int i, String dest, BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final parts = dest.split(' - ');
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(color: cs.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: cs.outlineVariant)),
      child: Row(children: [
        Icon(Icons.place, size: 22, color: cs.primary),
        SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(parts[0], style: AppTextStyle.bodyMd.copyWith(fontWeight: FontWeight.w600)),
          if (parts.length > 1) Text(parts[1], style: AppTextStyle.bodyMd.copyWith(color: cs.onSurfaceVariant, fontSize: 13)),
        ])),
        IconButton(icon: Icon(Icons.edit, size: 20, color: cs.onSurfaceVariant), onPressed: () {}),
        IconButton(icon: Icon(Icons.delete_outline, size: 20, color: cs.error), onPressed: () => setState(() => _destinations.removeAt(i))),
      ]),
    );
  }
}
