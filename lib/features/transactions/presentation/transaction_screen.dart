import 'package:flutter/material.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

const transactionIdTextHint = "Transaction ID";
const searchText = "Search";

class _TransactionScreenState extends State<TransactionScreen> {
  var transactionId = "";
  final Map<String, String> transactionDetails = {
    "Transaction ID": "0x1234567890",
    "Transaction type": "On-chain",
    "Transaction status": "Success",
    "Transaction time": "2021-10-10 10:10:10",
    "Transaction fee": "0.0001 ETH",
    "Transaction hash": "0x1234567890",
    "Block number": "1234567890",
    "Block hash": "0x1234567890",
    "From": "0x1234567890",
    "To": "0x1234567890",
    "Value": "0.0001 ETH",
    "Gas used by transaction": "1234567890",
    "Gas price": "1234567890"
  };
  //Widget that uses the transactionDetails map with line spacing
  Widget transactionDetailsWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: transactionDetails.entries
          .map((entry) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        entry.value,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  )
                ],
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: transactionIdTextHint,
                    ),
                    onChanged: (value) => setState(() {
                      transactionId = value;
                    }),
                  ),
                ),
                const SizedBox(width: 5),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {},
                  child: const Text(searchText),
                ),
              ],
            ),
            transactionDetailsWidget()
          ],
        ),
      ),
    );
  }
}
