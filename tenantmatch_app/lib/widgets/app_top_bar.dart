import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppTopBar extends StatelessWidget {
  final bool showBack;
  final String title;
  final List<Widget>? actions;

  const AppTopBar({
    super.key,
    this.showBack = true,
    this.title = 'TenantMatch',
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppTheme.containerMargin, vertical: 10),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(bottom: BorderSide(color: cs.outlineVariant, width: 0.5)),
      ),
      child: Row(
        children: [
          if (showBack)
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLowOf(context),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_back, size: 20, color: cs.primary),
              ),
            )
          else
            SizedBox(width: 36),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.real_estate_agent, size: 22, color: cs.primary),
                SizedBox(width: 6),
                Text(title, style: AppTextStyle.headlineMd.copyWith(color: cs.primary)),
              ],
            ),
          ),
          if (actions != null)
            ...actions!
          else
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/profile'),
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerHighestOf(context),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, size: 20, color: cs.onSurfaceVariant),
              ),
            ),
        ],
      ),
    );
  }
}
