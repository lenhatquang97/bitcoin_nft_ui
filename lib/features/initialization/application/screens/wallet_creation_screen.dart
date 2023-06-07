import 'package:flutter/material.dart';

class WalletCreationScreen extends StatefulWidget {
  const WalletCreationScreen({super.key});

  @override
  State<WalletCreationScreen> createState() => _WalletCreationScreenState();
}

class _WalletCreationScreenState extends State<WalletCreationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Align(
            alignment: Alignment.center,
            child: Text(
              "Wallet Creation Screen",
              style: TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              const Text("Passphrase"),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextFormField(
                    maxLines: 1,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Passphrase',
                    )),
              ))
            ],
          ),
          const SizedBox(height: 8.0),
          const Text("Mnemonic 24 words", style: TextStyle(fontWeight: FontWeight.bold),),
          const SizedBox(height: 8.0,),
          Expanded(
              child: TextFormField(
                  maxLines: 5,
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  )))
        ]),
      ),
    );
  }
}