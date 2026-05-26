import 'package:flutter/material.dart';

void showAppAlert(BuildContext context, String title, String message) {
  final cs = Theme.of(context).colorScheme;
  showDialog(
    context: context,
    builder: (ctx) => Semantics(
      label: 'Alert: $title',
      container: true,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: EdgeInsets.fromLTRB(24, 28, 24, 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              header: true,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: cs.primary,
                ),
              ),
            ),
            SizedBox(height: 8),
            Semantics(
              label: message,
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: cs.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Semantics(
                label: 'OK',
                button: true,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Text('OK'),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
