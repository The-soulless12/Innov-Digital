import 'package:flutter/material.dart';

class PressChip extends StatefulWidget {
  final String label;

  const PressChip({super.key, required this.label});

  @override
  State<PressChip> createState() => _PressChipState();
}

class _PressChipState extends State<PressChip> {
  bool _isPressed = false;

  final Color defaultBackgroundColor = const Color(0xFF5B2682); // Dark purple
  final Color pressedBackgroundColor = const Color(0xFFAA33FF); // Bright purple
  final Color defaultTextColor = const Color(0xFFAA33FF);
  final Color pressedTextColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true), // When pressed
      onTapUp: (_) => setState(() => _isPressed = false),   // When released
      onTapCancel: () => setState(() => _isPressed = false), // If the press is canceled
      child: Chip(
        label: Text(
          widget.label,
          style: TextStyle(
            color: _isPressed ? pressedTextColor : defaultTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor:
            _isPressed ? pressedBackgroundColor : defaultBackgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
