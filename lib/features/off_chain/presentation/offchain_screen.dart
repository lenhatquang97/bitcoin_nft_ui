import 'package:bitcoin_nft_ui/features/off_chain/presentation/see_offchain_nft_screen.dart';
import 'package:bitcoin_nft_ui/features/off_chain/presentation/send_and_export_proof_screen.dart';
import 'package:flutter/material.dart';

class OffChainScreen extends StatelessWidget {
  const OffChainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            bottom: const TabBar(
              tabs: [
                Tab(icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Send and export proof', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                )),
                Tab(icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Your NFTs and import proof', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                )),
              ],
            )
          ),
          body: const TabBarView(
            children: [
              SendAndExportProofScreen(),
              SeeOffChainNftScreen()
            ],
          ),
        ),
      );
  }
}