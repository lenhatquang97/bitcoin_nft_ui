import 'dart:math';

import 'package:bitcoin_nft_ui/features/transactions/data/transaction_api.dart';
import 'package:bitcoin_nft_ui/features/transactions/domain/transaction_domain.dart';
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
  var searchedTx = GetTransactionResponse.init();
  //Widget that uses the transactionDetails map with line spacing
  Widget transactionDetailsWidget(Map<String, String> mp) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: mp.entries
          .map((entry) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          entry.key,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
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
                  onPressed: () async{
                    final res = await TransactionDomain.getTransactionDomain(transactionId);
                    setState(() {
                      searchedTx = res;
                    });
                  },
                  child: const Text(searchText),
                ),
              ],
            ),
            transactionDetailsWidget(searchedTx.outputToMap()),
            ...searchedTx.vin.asMap().map((i, e) => MapEntry(i, Column(
              children: [
                const SizedBox(height: 20,),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("InputIndex: $i", style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline, fontSize: 16))),
                transactionDetailsWidget(e.outputToMap())
              ],
            ))).values.toList(),
            const SizedBox(height: 20,),
            ...searchedTx.vout.asMap().map((i, e) => MapEntry(i, Column(
              children: [
                const SizedBox(height: 20,),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("OutputIndex: $i", style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline, fontSize: 16))),
                transactionDetailsWidget(e.outputToMap())
              ],
            ))).values.toList(),
          ],
        ),
      ),
    );
  }
}
