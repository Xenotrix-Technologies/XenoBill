import 'package:flutter/material.dart';

class FloatingAddInvoiceButton extends StatelessWidget {
  final VoidCallback onTap;

  const FloatingAddInvoiceButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const String tooltipText = 'Add Invoice';
    const buttonColor = Color(0xFF2563EB); // Royal Vibrant Blue from reference image 2

    return Tooltip(
      message: tooltipText,
      child: Semantics(
        label: tooltipText,
        button: true,
        container: true,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: buttonColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: buttonColor.withAlpha(70),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}
