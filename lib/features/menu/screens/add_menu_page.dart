import 'package:flutter/material.dart';
import '../../../common/theme/app_colors.dart';

class AddMenuPage extends StatelessWidget {
  const AddMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Add Menu Item"),
        backgroundColor: AppColors.background,
      ),
      body: const Center(
        child: Text("Add Menu Item Form Here"),
      ),
    );
  }
}