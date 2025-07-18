import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Text(
            context.l10n.yourInvoicingSolution,
            style: TextStyle(
              fontSize: 18,
              color: AppColors.subtitleColor(context, opacity: 0.8),
              letterSpacing: 0.5,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
