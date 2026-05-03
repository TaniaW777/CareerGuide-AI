import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SelectButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const SelectButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : (isDark ? Colors.white10 : Colors.grey[100]),
          border: Border.all(
            color: isSelected ? AppColors.primaryLight : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.white : (isDark ? Colors.white : Colors.black87),
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
