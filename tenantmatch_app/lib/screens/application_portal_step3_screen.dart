import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_top_bar.dart';

class ApplicationPortalStep3Screen extends StatefulWidget {
  const ApplicationPortalStep3Screen({super.key});

  @override
  State<ApplicationPortalStep3Screen> createState() => _ApplicationPortalStep3ScreenState();
}

class _ApplicationPortalStep3ScreenState extends State<ApplicationPortalStep3Screen> {
  final _refs = ['Ref 1', 'Ref 2'];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(title: 'References'),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppTheme.containerMargin),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('APPLICATION PROGRESS', style: AppTextStyle.labelCaps.copyWith(color: cs.onSurfaceVariant)),
                SizedBox(height: 4),
                Text('References', style: AppTextStyle.headlineLgMobile.copyWith(color: cs.primary)),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Step 3 of 4', style: AppTextStyle.headlineSm.copyWith(color: cs.secondary)),
                ]),
                SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(value: 0.75, backgroundColor: AppTheme.surfaceContainerHighestOf(context), valueColor: AlwaysStoppedAnimation(cs.secondary), minHeight: 8),
                ),
              ]),
            ),
            SizedBox(height: AppTheme.spacingMd),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(AppTheme.containerMargin),
                children: [
                  ..._refs.asMap().entries.map((e) => Container(
                    margin: EdgeInsets.only(bottom: AppTheme.gutter),
                    padding: EdgeInsets.all(AppTheme.spacingMd),
                    decoration: BoxDecoration(color: cs.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: cs.outlineVariant)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Icon(Icons.person_outline, color: cs.primary),
                        SizedBox(width: 8),
                        Text('Reference ${e.key + 1}', style: AppTextStyle.headlineSm.copyWith(color: cs.primary)),
                      ]),
                      SizedBox(height: 12),
                      _field('Full Name', context),
                      SizedBox(height: 12),
                      _field('Email', context),
                      SizedBox(height: 12),
                      _field('Phone', context),
                      SizedBox(height: 12),
                      _field('Relationship', context),
                    ]),
                  )),
                  GestureDetector(
                    onTap: () => setState(() => _refs.add('Ref ${_refs.length + 1}')),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: cs.outlineVariant, style: BorderStyle.solid, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(Icons.add, color: cs.primary),
                        SizedBox(width: 8),
                        Text('Add Reference', style: AppTextStyle.headlineSm.copyWith(color: cs.primary)),
                      ]),
                    ),
                  ),
                  SizedBox(height: AppTheme.spacingLg),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/app-step2'),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(border: Border.all(color: cs.secondary), borderRadius: BorderRadius.circular(12)),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Icon(Icons.arrow_back, size: 18, color: cs.secondary),
                              SizedBox(width: 4),
                              Text('Back', style: AppTextStyle.headlineSm.copyWith(color: cs.secondary)),
                            ]),
                          ),
                        ),
                      ),
                      SizedBox(width: AppTheme.gutter),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/app-step4'),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(12)),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Text('Save & Continue', style: AppTextStyle.headlineSm.copyWith(color: cs.onPrimary)),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward, size: 18, color: cs.onPrimary),
                            ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTextStyle.labelCaps.copyWith(color: cs.onSurfaceVariant)),
      SizedBox(height: 4),
      TextField(
        decoration: InputDecoration(
          filled: true, fillColor: cs.surface,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: AppTextStyle.bodyMd,
      ),
    ]);
  }
}
