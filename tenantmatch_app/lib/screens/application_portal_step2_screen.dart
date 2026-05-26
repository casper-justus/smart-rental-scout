import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/toast.dart';

class ApplicationPortalStep2Screen extends StatefulWidget {
  const ApplicationPortalStep2Screen({super.key});

  @override
  State<ApplicationPortalStep2Screen> createState() => _ApplicationPortalStep2ScreenState();
}

class _ApplicationPortalStep2ScreenState extends State<ApplicationPortalStep2Screen> {
  final List<String> _uploadedDocs = ['Paystub_June_2023.pdf'];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(title: 'Documents'),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppTheme.containerMargin),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('APPLICATION PROGRESS', style: AppTextStyle.labelCaps.copyWith(color: cs.onSurfaceVariant)),
                SizedBox(height: 4),
                Text('Personal Documentation', style: AppTextStyle.headlineLgMobile.copyWith(color: cs.primary)),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Step 2 of 4', style: AppTextStyle.headlineSm.copyWith(color: cs.secondary)),
                ]),
                SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(value: 0.5, backgroundColor: AppTheme.surfaceContainerHighestOf(context), valueColor: AlwaysStoppedAnimation(cs.secondary), minHeight: 8),
                ),
              ]),
            ),
            SizedBox(height: AppTheme.spacingMd),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(AppTheme.containerMargin),
                children: [
                  Container(
                    padding: EdgeInsets.all(AppTheme.spacingMd),
                    decoration: BoxDecoration(color: cs.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: cs.outlineVariant)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Icon(Icons.badge, color: cs.primary),
                        SizedBox(width: 8),
                        Text('Photo Identification', style: AppTextStyle.headlineSm.copyWith(color: cs.primary)),
                      ]),
                      SizedBox(height: 8),
                      Text('Upload a valid government-issued ID.', style: AppTextStyle.bodyMd.copyWith(color: cs.onSurfaceVariant)),
                      SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {
                          showToast(context, 'File upload triggered!');
                        },
                        child: Container(
                          padding: EdgeInsets.all(AppTheme.spacingLg),
                          decoration: BoxDecoration(
                            border: Border.all(color: cs.outlineVariant, style: BorderStyle.solid, width: 2),
                            borderRadius: BorderRadius.circular(8),
                            color: AppTheme.surfaceContainerLowOf(context),
                          ),
                          child: Column(children: [
                            Icon(Icons.cloud_upload, size: 40, color: cs.onSurfaceVariant),
                            SizedBox(height: 8),
                            Text('Click to upload', style: AppTextStyle.headlineSm.copyWith(color: cs.primary)),
                            Text('SVG, PNG, JPG or PDF (max. 10MB)', style: AppTextStyle.labelCaps.copyWith(color: cs.onSurfaceVariant)),
                          ]),
                        ),
                      ),
                    ]),
                  ),
                  SizedBox(height: AppTheme.gutter),
                  Container(
                    padding: EdgeInsets.all(AppTheme.spacingMd),
                    decoration: BoxDecoration(color: cs.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: cs.outlineVariant)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Icon(Icons.account_balance_wallet, color: cs.primary),
                        SizedBox(width: 8),
                        Text('Proof of Income', style: AppTextStyle.headlineSm.copyWith(color: cs.primary)),
                      ]),
                      SizedBox(height: 8),
                      Text('Please provide your three most recent paystubs.', style: AppTextStyle.bodyMd.copyWith(color: cs.onSurfaceVariant)),
                      SizedBox(height: 12),
                      ..._uploadedDocs.map((doc) => Container(
                        margin: EdgeInsets.only(bottom: 8),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(color: AppTheme.surfaceContainerOf(context), borderRadius: BorderRadius.circular(8), border: Border.all(color: cs.outlineVariant)),
                        child: Row(children: [
                          Icon(Icons.description, size: 20, color: cs.secondary),
                          SizedBox(width: 8),
                          Expanded(child: Text(doc, style: AppTextStyle.bodyMd.copyWith(color: cs.primary))),
                          GestureDetector(
                            onTap: () => setState(() => _uploadedDocs.remove(doc)),
                            child: Icon(Icons.delete, size: 20, color: cs.error),
                          ),
                        ]),
                      )),
                      GestureDetector(
                        onTap: () {
                          setState(() => _uploadedDocs.add('Document_${_uploadedDocs.length + 1}.pdf'));
                          showToast(context, 'Document added!');
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: cs.outlineVariant, style: BorderStyle.solid, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Icon(Icons.add, color: cs.primary),
                            SizedBox(width: 8),
                            Text('Add another document', style: AppTextStyle.headlineSm.copyWith(color: cs.primary)),
                          ]),
                        ),
                      ),
                    ]),
                  ),
                  SizedBox(height: AppTheme.spacingLg),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/app-step1'),
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
                          onTap: () => Navigator.pushNamed(context, '/app-step3'),
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
}
