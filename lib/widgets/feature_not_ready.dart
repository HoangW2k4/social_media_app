import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

/// Show a "feature not ready" popup dialog.
void showFeatureNotReady(
  BuildContext context, {
  IconData icon = Icons.construction_rounded,
  String? featureNameKey,
}) {
  showDialog(
    context: context,
    builder: (_) =>
        _FeatureNotReadyDialog(icon: icon, featureNameKey: featureNameKey),
  );
}

class _FeatureNotReadyDialog extends StatelessWidget {
  final IconData icon;
  final String? featureNameKey;

  const _FeatureNotReadyDialog({required this.icon, this.featureNameKey});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final featureName = featureNameKey != null
        ? t.translate(featureNameKey!)
        : null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 44, color: Colors.blue.shade400),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              t.translate('feature_not_ready_title'),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Subtitle
            Text(
              t.translate('feature_not_ready_subtitle'),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            // Optional feature name chip
            if (featureName != null) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 16, color: Colors.blue),
                    const SizedBox(width: 6),
                    Text(
                      featureName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 22),

            // Close button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(t.translate('feature_not_ready_go_back')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
