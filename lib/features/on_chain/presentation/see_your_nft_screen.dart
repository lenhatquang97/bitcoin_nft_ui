import 'package:bitcoin_nft_ui/features/on_chain/data/nft_getter.dart';
import 'package:bitcoin_nft_ui/features/on_chain/domain/nft_getter_domain.dart';
import 'package:bitcoin_nft_ui/ui/file_renderer.dart';
import 'package:flutter/material.dart';

class SeeYourNftScreen extends StatefulWidget {
  const SeeYourNftScreen({super.key});

  @override
  State<SeeYourNftScreen> createState() => _SeeYourNftScreenState();
}

const seeYourNftText = "Your NFT Collection";
const refreshText = "Refresh";

class _SeeYourNftScreenState extends State<SeeYourNftScreen> {
  final List<NftStructure> availableNfts = [];

  void onRefresh() async {
    final value = await NftGetterDomain.nftGetterDomain(
        "n1Nd8J38uyDRLwh5ShAAPvbNrqBD1wee8v");
    setState(() {
      availableNfts.clear();
      availableNfts.addAll(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              seeYourNftText,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            buildGrid(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size.fromHeight(60),
              ),
              onPressed: onRefresh,
              child: const Text(refreshText),
            )
          ],
        ),
      ),
    );
  }

  //Generate widget that displays grid of NFTs but no line space
  Widget buildGrid() => GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: availableNfts.map(buildFile).toList(),
      );

  Widget buildFile(NftStructure structure) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Align(
            //     alignment: Alignment.center,
            //     child: Icon(Icons.text_snippet, size: 120, color: Colors.red)),
            FileRendererWidget(hexStr: structure.hexData, mimeType: structure.mimeType, txId: structure.txId),
            const SizedBox(height:20),
            Flexible(
                child: Text("Transaction ID: ${structure.txId}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold))),
          ],
        ),
      );
}
