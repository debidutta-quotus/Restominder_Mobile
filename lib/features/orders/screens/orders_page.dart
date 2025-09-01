import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "🛒 Orders Page",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
