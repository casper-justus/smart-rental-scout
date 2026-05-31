import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_top_bar.dart';

class ApplicationPortalStep1Screen extends StatefulWidget {
  const ApplicationPortalStep1Screen({super.key});

  @override
  State<ApplicationPortalStep1Screen> createState() => _ApplicationPortalStep1ScreenState();
}

class _ApplicationPortalStep1ScreenState extends State<ApplicationPortalStep1Screen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(title: 'Application'),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppTheme.containerMargin),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('APPLICATION PROGRESS', style: AppTextStyle.labelCaps.copyWith(color: cs.onSurfaceVariant)),
                SizedBox(height: 4),
                Text('Personal Information', style: AppTextStyle.headlineLgMobile.copyWith(color: cs.primary)),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Step 1 of 4', style: AppTextStyle.headlineSm.copyWith(color: cs.secondary)),
                ]),
                SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(value: 0.25, backgroundColor: AppTheme.surfaceContainerHighestOf(context), valueColor: AlwaysStoppedAnimation(cs.secondary), minHeight: 8),
                ),
              ]),
            ),
            SizedBox(height: AppTheme.spacingMd),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(AppTheme.containerMargin),
                  children: [
                    _field('Full Legal Name', Icons.person, context),
                    SizedBox(height: AppTheme.spacingMd),
                    _field('Email Address', Icons.email, context, type: TextInputType.emailAddress),
                    SizedBox(height: AppTheme.spacingMd),
                    _field('Phone Number', Icons.phone, context, type: TextInputType.phone),
                    SizedBox(height: AppTheme.spacingMd),
                    _field('Current Address', Icons.home, context),
                    SizedBox(height: AppTheme.spacingMd),
                    _field('Social Security (last 4)', Icons.lock, context),
                    SizedBox(height: AppTheme.spacingLg),
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pushNamed(context, '/app-step2');
                        }
                      },
                      child: Container(
                        width: double.infinity, padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(12)),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text('Continue to Documents', style: AppTextStyle.headlineSm.copyWith(color: cs.onPrimary)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: cs.onPrimary),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, IconData icon, BuildContext context, {TextInputType? type}) {
    final cs = Theme.of(context).colorScheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTextStyle.labelCaps.copyWith(color: cs.onSurfaceVariant)),
      SizedBox(height: 4),
      TextFormField(
        keyboardType: type,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 20, color: cs.onSurfaceVariant),
          filled: true, fillColor: cs.surface,
          border: InputBorder.none,
        ),
        style: AppTextStyle.bodyMd,
        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
      ),
    ]);
  }
}
