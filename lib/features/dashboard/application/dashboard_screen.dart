import 'package:bitcoin_nft_ui/features/off_chain/application/offchain_screen.dart';
import 'package:bitcoin_nft_ui/features/on_chain/application/on_chain_screen.dart';
import 'package:bitcoin_nft_ui/features/transactions/application/transaction_screen.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_box),
                    SizedBox(width: 2),
                    Text('On-chain', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                )),
                Tab(icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.offline_bolt),
                    SizedBox(width: 2),
                    Text('Off-chain', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                )),
                Tab(icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.currency_bitcoin),
                    SizedBox(width: 2),
                    Text('Transactions', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                )),
              ],
            ),
            title: const Text('NFT Wallet'),
          ),
          body: const TabBarView(
            children: [
              OnChainScreen(),
              OffChainScreen(),
              TransactionScreen()
            ],
          ),
        ),
      );
  }
}