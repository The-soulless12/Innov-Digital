import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AISearchBar extends StatelessWidget {
  const AISearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Ask me anything...',
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SvgPicture.asset('assets/Robot.svg', width: 24, height: 24),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/microphone-2.svg',
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 12),
              SvgPicture.asset('assets/send.svg', width: 24, height: 24),
            ],
          ),
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 255, 255, 255),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
