import 'package:flutter/material.dart';

class OpenMapButton extends StatelessWidget {
  final VoidCallback onPressed;

  const OpenMapButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.map),
      label: const Text('Open in Maps'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.2),
        foregroundColor: Colors.white,
      ),
    );
  }
}

