import 'package:bitcoin_nft_ui/features/on_chain/data/nft_getter.dart';
import 'package:bitcoin_nft_ui/features/on_chain/domain/nft_getter_domain.dart';
import 'package:flutter/material.dart';
class SeeYourNftScreen extends StatefulWidget {
  const SeeYourNftScreen({super.key});

  @override
  State<SeeYourNftScreen> createState() => _SeeYourNftScreenState();
}

const seeYourNftText = "See your NFTs";
const refreshText = "Refresh";

class _SeeYourNftScreenState extends State<SeeYourNftScreen> {
  final List<NftStructure> availableNfts = [];
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
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size.fromHeight(60),
              ),
              onPressed: () async {
                final value = await NftGetterDomain.nftGetterDomain("n1Nd8J38uyDRLwh5ShAAPvbNrqBD1wee8v");
                setState(() {
                  availableNfts.clear();
                  availableNfts.addAll(value);
                });
              },
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
            const Align(
              alignment: Alignment.center,
              child: Icon(Icons.text_snippet, size: 120, color: Colors.red)),
            const SizedBox(height: 20),
            Flexible(child: Text(structure.txId, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            const SizedBox(height: 20),
            Text(structure.mimeType)
          ],
        ),
      );
}
