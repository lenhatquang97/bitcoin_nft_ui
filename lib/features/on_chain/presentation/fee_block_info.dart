import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FeeBlockWidget extends StatelessWidget {
  final String feeTitle;
  final int feeValue;
  final double transactionSize;
  final VoidCallback voidCallback;
  final int feeNumber;
  int satoshiReceive;
  int transactionFeeChoice;
  
  FeeBlockWidget({super.key, required this.feeTitle, required this.feeValue, required this.transactionSize, required this.satoshiReceive, required this.transactionFeeChoice, required this.feeNumber, required this.voidCallback});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: voidCallback,
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: transactionFeeChoice == feeNumber ? Colors.blue : Colors.black,
            borderRadius: BorderRadius.circular(16)
          ),
          child: Column(
            children: [
              Text(feeTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Text("${(feeValue + satoshiReceive).round()} satoshis", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
              const SizedBox(height: 20),
              Text("$feeValue service fee"),
            ],
          ),
        ),
      ),
    );
  }
}