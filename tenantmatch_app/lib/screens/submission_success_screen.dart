import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SubmissionSuccessScreen extends StatelessWidget {
  const SubmissionSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(AppTheme.containerMargin),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    color: cs.secondaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check_circle, size: 48, color: cs.onSecondaryContainer),
                ),
                SizedBox(height: AppTheme.spacingLg),
                Text('Application Submitted!', style: AppTextStyle.headlineLgMobile.copyWith(color: cs.primary)),
                SizedBox(height: AppTheme.spacingSm),
                Text(
                  'Your application has been successfully submitted. The landlord will review your profile within 24-48 hours.',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.bodyLg.copyWith(color: cs.onSurfaceVariant),
                ),
                SizedBox(height: AppTheme.spacingLg),
                Icon(Icons.hourglass_empty, size: 64, color: cs.primaryContainer),
                SizedBox(height: AppTheme.spacingLg),
                GestureDetector(
                  onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => true),
                  child: Container(
                    width: double.infinity, padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(12)),
                    child: Text('Return to Home', textAlign: TextAlign.center, style: AppTextStyle.headlineSm.copyWith(color: cs.onPrimary)),
                  ),
                ),
                SizedBox(height: AppTheme.gutter),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/app-step4'),
                  child: Container(
                    width: double.infinity, padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(border: Border.all(color: cs.secondary), borderRadius: BorderRadius.circular(12)),
                    child: Text('View Application Status', textAlign: TextAlign.center, style: AppTextStyle.headlineSm.copyWith(color: cs.secondary)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
