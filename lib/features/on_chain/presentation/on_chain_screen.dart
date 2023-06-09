import 'package:bitcoin_nft_ui/features/on_chain/presentation/create_inscription_screen.dart';
import 'package:bitcoin_nft_ui/features/on_chain/presentation/see_your_nft_screen.dart';
import 'package:bitcoin_nft_ui/features/on_chain/presentation/send_inscription.dart';
import 'package:flutter/material.dart';

class OnChainScreen extends StatelessWidget {
  const OnChainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            bottom: const TabBar(
              tabs: [
                Tab(icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Upload inscription', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                )),
                Tab(icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Send inscription', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                )),
                Tab(icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Your NFTs', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                )),
              ],
            )
          ),
          body: const TabBarView(
            children: [
              CreateInscriptionScreen(),
              SendInscriptionScreen(),
              SeeYourNftScreen()
            ],
          ),
        ),
      );
  }
}