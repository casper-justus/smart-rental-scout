import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_dialog.dart';
import '../widgets/app_top_bar.dart';

class ApplicationPortalStep4ReviewScreen extends StatefulWidget {
  const ApplicationPortalStep4ReviewScreen({super.key});

  @override
  State<ApplicationPortalStep4ReviewScreen> createState() => _ApplicationPortalStep4ReviewScreenState();
}

class _ApplicationPortalStep4ReviewScreenState extends State<ApplicationPortalStep4ReviewScreen> {
  bool _termsAccepted = false;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(title: 'Review & Submit'),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppTheme.containerMargin),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('APPLICATION PROGRESS', style: AppTextStyle.labelCaps.copyWith(color: cs.onSurfaceVariant)),
                SizedBox(height: 4),
                Text('Review & Submit', style: AppTextStyle.headlineLgMobile.copyWith(color: cs.primary)),
                Text('STEP 4 OF 4', style: AppTextStyle.headlineSm.copyWith(color: cs.secondary)),
                SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(value: 1.0, backgroundColor: AppTheme.surfaceContainerHighestOf(context), valueColor: AlwaysStoppedAnimation(cs.secondary), minHeight: 8),
                ),
              ]),
            ),
            SizedBox(height: AppTheme.spacingMd),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(AppTheme.containerMargin),
                children: [
                  _reviewSection('Personal Information', 'Jane Doe\njane.doe@email.com\n+1 (555) 123-4567', () => Navigator.pushNamed(context, '/app-step1'), context),
                  SizedBox(height: AppTheme.gutter),
                  _reviewSection('Documents', 'Photo ID: Uploaded\nProof of Income: 1 file', () => Navigator.pushNamed(context, '/app-step2'), context),
                  SizedBox(height: AppTheme.gutter),
                  _reviewSection('References', '2 references provided', () => Navigator.pushNamed(context, '/app-step3'), context),
                  SizedBox(height: AppTheme.spacingLg),
                  CheckboxListTile(
                    title: Text('I agree to the Terms & Conditions', style: AppTextStyle.bodyMd),
                    value: _termsAccepted,
                    onChanged: (v) => setState(() => _termsAccepted = v ?? false),
                    activeColor: cs.primary,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  SizedBox(height: AppTheme.spacingMd),
                  GestureDetector(
                    onTap: _submitApplication,
                    child: Container(
                      width: double.infinity, padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: _termsAccepted ? cs.primary : AppTheme.surfaceContainerHighestOf(context),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _isSubmitting
                        ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                            SizedBox(width: 8),
                            Text('Processing...', style: AppTextStyle.headlineSm.copyWith(color: cs.onPrimary)),
                          ])
                        : Text('Submit Application', textAlign: TextAlign.center, style: AppTextStyle.headlineSm.copyWith(color: _termsAccepted ? cs.onPrimary : cs.onSurfaceVariant)),
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

  void _submitApplication() {
    if (!_termsAccepted) {
      showAppAlert(context, 'Terms Required', 'Please agree to the terms first.');
      return;
    }
    setState(() => _isSubmitting = true);
    Future.delayed(Duration(seconds: 2), () {
      setState(() => _isSubmitting = false);
      showAppAlert(context, 'Application Submitted!', 'Your application for The Lumina - Unit 4B has been successfully submitted!');
      Navigator.pushNamedAndRemoveUntil(context, '/submission-success', (_) => true);
    });
  }

  Widget _reviewSection(String title, String content, VoidCallback onEdit, BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(color: cs.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: cs.outlineVariant)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title, style: AppTextStyle.headlineSm.copyWith(color: cs.primary)),
          GestureDetector(
            onTap: onEdit,
            child: Row(children: [
              Icon(Icons.edit, size: 16, color: cs.primary),
              SizedBox(width: 4),
              Text('Edit', style: AppTextStyle.bodyMd.copyWith(color: cs.primary)),
            ]),
          ),
        ]),
        SizedBox(height: 8),
        Text(content, style: AppTextStyle.bodyMd.copyWith(color: cs.onSurfaceVariant)),
      ]),
    );
  }
}
