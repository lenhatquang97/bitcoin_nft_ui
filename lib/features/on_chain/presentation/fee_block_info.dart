import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FeeBlockWidget extends StatelessWidget {
  final int feeValue;
  
  const FeeBlockWidget({super.key, required this.feeValue});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(16)
        ),
        child: Column(
          children: [
            const Text("Transaction fee", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text("$feeValue service fee", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), 
          ],
        ),
      ),
    );
  }
}