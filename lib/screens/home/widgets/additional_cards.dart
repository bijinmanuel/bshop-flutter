import 'package:flutter/material.dart';

class AdditionalCards extends StatelessWidget {
  const AdditionalCards({
    super.key,
    required this.icon,
    required this.label,
    required this.backgroundColor,
  });
  final IconData icon;
  final String label;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, color: backgroundColor, size: 18),
      label: Text(label),
      backgroundColor: backgroundColor.withValues(alpha: 0.08),
      labelStyle: TextStyle(fontWeight: FontWeight.w500),
    );
  }
}
