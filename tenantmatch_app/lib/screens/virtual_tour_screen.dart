import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_dialog.dart';
import '../widgets/app_top_bar.dart';

class VirtualTourScreen extends StatefulWidget {
  const VirtualTourScreen({super.key});

  @override
  State<VirtualTourScreen> createState() => _VirtualTourScreenState();
}

class _VirtualTourScreenState extends State<VirtualTourScreen> {
  final _rooms = [
    {'name': 'Living Room', 'icon': Icons.living, 'desc': 'Open concept with city views'},
    {'name': 'Kitchen', 'icon': Icons.kitchen, 'desc': 'Stainless steel appliances'},
    {'name': 'Master Bedroom', 'icon': Icons.bed, 'desc': 'Walk-in closet, en-suite'},
    {'name': 'Bedroom 2', 'icon': Icons.bedroom_parent, 'desc': 'Great for home office'},
    {'name': 'Bathroom', 'icon': Icons.bathtub, 'desc': 'Modern fixtures'},
    {'name': 'Balcony', 'icon': Icons.deck, 'desc': 'City skyline view'},
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
              title: 'Virtual Tour',
              actions: [
                GestureDetector(
                  onTap: () => showAppAlert(context, '360 View', 'Drag to look around the space.'),
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(color: cs.secondaryContainer, shape: BoxShape.circle),
                    child: Icon(Icons.view_in_ar, size: 20, color: cs.onSecondaryContainer),
                  ),
                ),
              ],
            ),
            Container(
              height: 300,
              margin: EdgeInsets.all(AppTheme.containerMargin),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [cs.primaryContainer, cs.tertiaryContainer],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.view_in_ar, size: 64, color: Colors.white.withOpacity(0.5)),
                    SizedBox(height: 12),
                    Text('360° Tour', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
                    SizedBox(height: 4),
                    Text('Drag to explore', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    SizedBox(height: 16),
                    Wrap(spacing: 8, children: [
                      _hotspot('Kitchen', () => showAppAlert(context, 'Kitchen Tour', 'This would transition to a 360 view of the kitchen with detailed material information.'), context),
                      _hotspot('Master Bedroom', () => showAppAlert(context, 'Master Bedroom', 'This would transition to a 360 view of the master bedroom with walk-in closet details.'), context),
                    ]),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppTheme.containerMargin),
              child: Text('Rooms', style: AppTextStyle.headlineMd.copyWith(color: cs.primary)),
            ),
            SizedBox(height: AppTheme.spacingSm),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: AppTheme.containerMargin),
                itemCount: _rooms.length,
                itemBuilder: (_, i) {
                  final r = _rooms[i];
                  return GestureDetector(
                    onTap: () => showAppAlert(context, 'Navigate to ${r['name']}', 'This would transition the virtual tour to the ${r['name']} view.\n\n${r['desc']}'),
                    child: Container(
                      margin: EdgeInsets.only(bottom: AppTheme.spacingSm),
                      padding: EdgeInsets.all(AppTheme.spacingMd),
                      decoration: BoxDecoration(
                        color: cs.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: cs.outlineVariant),
                      ),
                      child: Row(children: [
                        Icon(r['icon'] as IconData, color: cs.primary),
                        SizedBox(width: 16),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(r['name'] as String, style: AppTextStyle.headlineSm.copyWith(color: cs.onSurface)),
                          Text(r['desc'] as String, style: AppTextStyle.bodyMd.copyWith(color: cs.onSurfaceVariant)),
                        ])),
                        Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
                      ]),
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

  Widget _hotspot(String label, VoidCallback onTap, BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: cs.surface.withOpacity(0.9),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(label, style: AppTextStyle.bodyMd.copyWith(color: cs.primary, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
