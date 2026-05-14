import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String)? onChanged;
  final VoidCallback? onSubmitted;
  final IconData prefixIcon;
  final bool isRounded;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon = Icons.search,
    this.isRounded = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(isRounded ? 40 : 12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200, width: 1.5),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          color: isDark ? AppColors.onSurfaceDark : Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
            size: 22,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          border: InputBorder.none,
        ),
        onChanged: onChanged,
        onSubmitted: (_) => onSubmitted?.call(),
      ),
    );
  }
}
