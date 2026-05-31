import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/theme_service.dart';

import '../widgets/app_top_bar.dart';
import '../widgets/toast.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _nameCtrl = TextEditingController(text: 'Jane Doe');
  final _emailCtrl = TextEditingController(text: 'jane.doe@email.com');
  final _phoneCtrl = TextEditingController(text: '+1 (555) 123-4567');
  final _aboutCtrl = TextEditingController(text: 'Looking for a pet-friendly apartment near public transit.');
  bool _emailNotif = true;
  bool _smsAlerts = false;

  @override
  void initState() {
    super.initState();
    ThemeService.modeNotifier.addListener(_onThemeChange);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _aboutCtrl.dispose();
    ThemeService.modeNotifier.removeListener(_onThemeChange);
    super.dispose();
  }

  void _onThemeChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              title: 'Profile',
              actions: [
                GestureDetector(
                  onTap: () => showToast(context, 'Profile saved!'),
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(color: AppTheme.surfaceContainerLowOf(context), shape: BoxShape.circle),
                    child: Icon(Icons.check, size: 20, color: cs.primary),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(AppTheme.containerMargin),
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: cs.primaryContainer,
                          child: Icon(Icons.person, size: 48, color: cs.onPrimary),
                        ),
                        Positioned(bottom: 0, right: 0,
                          child: GestureDetector(
                            onTap: () => showToast(context, 'Photo upload triggered!'),
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(color: cs.primary, shape: BoxShape.circle),
                              child: Icon(Icons.edit, size: 16, color: cs.onPrimary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppTheme.spacingLg),
                  _field('Full Name', _nameCtrl, context),
                  SizedBox(height: AppTheme.spacingMd),
                  _field('Email', _emailCtrl, context),
                  SizedBox(height: AppTheme.spacingMd),
                  _field('Phone', _phoneCtrl, context, type: TextInputType.phone),
                  SizedBox(height: AppTheme.spacingMd),
                  _field('About', _aboutCtrl, context, maxLines: 3),
                  SizedBox(height: AppTheme.spacingLg),
                  _toggle('Email Notifications', _emailNotif, (v) { setState(() { _emailNotif = v; }); }, context),
                  _toggle('SMS Alerts', _smsAlerts, (v) { setState(() { _smsAlerts = v; }); }, context),
                  _themeRow(context),
                  SizedBox(height: AppTheme.spacingLg),
                  GestureDetector(
                    onTap: () { showToast(context, 'Profile saved!'); },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(12)),
                      child: Text('Save Changes', textAlign: TextAlign.center, style: AppTextStyle.headlineSm.copyWith(color: cs.onPrimary)),
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

  Widget _field(String label, TextEditingController ctrl, BuildContext context, {int maxLines = 1, TextInputType? type}) {
    final cs = Theme.of(context).colorScheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTextStyle.labelCaps.copyWith(color: cs.onSurfaceVariant)),
      SizedBox(height: 4),
      TextField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: type,
        decoration: InputDecoration(
          filled: true, fillColor: cs.surface,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: AppTextStyle.bodyMd,
      ),
    ]);
  }

  Widget _toggle(String label, bool value, ValueChanged<bool> onChanged, BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: AppTextStyle.bodyMd),
        Switch(value: value, onChanged: onChanged, activeColor: cs.primary),
      ]),
    );
  }

  Widget _themeRow(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Theme', style: AppTextStyle.bodyMd),
        GestureDetector(
          onTap: () {
            ThemeService.cycleMode();
            setState(() {});
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  ThemeService.modeNotifier.value == ThemeMode.system
                      ? Icons.brightness_auto
                      : ThemeService.modeNotifier.value == ThemeMode.dark
                          ? Icons.dark_mode
                          : Icons.light_mode,
                  size: 18,
                  color: cs.primary,
                ),
                SizedBox(width: 8),
                Text(ThemeService.label, style: AppTextStyle.bodyMd.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
