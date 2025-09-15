// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final VoidCallback? onEdit;

  const ProfileSection({
    super.key,
    required this.title,
    required this.children,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                if (onEdit != null)
                  GestureDetector(
                    onTap: onEdit,
                    child: const Icon(
                      Icons.edit,
                      color: Colors.black54,
                      size: 18,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}