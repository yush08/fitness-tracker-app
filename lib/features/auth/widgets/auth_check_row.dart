import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Small orange checkbox + label (Remember Me / Show Password).
class AuthCheckRow extends StatelessWidget {
  final bool value;
  final String label;
  final ValueChanged<bool> onChanged;

  static const Color _orange = Color(0xFF9C8BF5);

  const AuthCheckRow({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: value ? _orange : Colors.transparent,
              border: Border.all(color: _orange, width: 1.6),
              borderRadius: BorderRadius.circular(4),
            ),
            child: value
                ? const Icon(Icons.check, size: 13, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _orange,
            ),
          ),
        ],
      ),
    );
  }
}
