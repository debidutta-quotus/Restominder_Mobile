import 'package:flutter/material.dart';

class DayChip extends StatelessWidget {
  final String day;
  final bool isOpen;

  const DayChip({
    super.key,
    required this.day,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isOpen ? Colors.green.shade50 : Colors.red.shade50,
        border: Border.all(
          color: isOpen ? Colors.green.shade300 : Colors.red.shade300,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: isOpen 
        ? Text(
            day,
            style: TextStyle(
              color: Colors.green.shade700,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              Text(
                day,
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 1,
                    width: day.length * 6.0,
                    color: Colors.red.shade700,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}