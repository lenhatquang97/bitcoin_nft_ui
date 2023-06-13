import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FeeBlockWidget extends StatelessWidget {
  final int feeValue;
  int satoshiReceive;
  
  FeeBlockWidget({super.key, required this.feeValue, required this.satoshiReceive});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(16)
        ),
        child: Column(
          children: [
            const Text("Transaction fee", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text("${(feeValue + satoshiReceive).round()} satoshis", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            const SizedBox(height: 20),
            Text("$feeValue service fee"),
          ],
        ),
      ),
    );
  }
}