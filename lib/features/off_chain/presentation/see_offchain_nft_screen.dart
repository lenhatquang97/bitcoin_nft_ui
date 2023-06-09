import 'package:flutter/material.dart';

class SeeOffChainNftScreen extends StatefulWidget {
  const SeeOffChainNftScreen({super.key});

  @override
  State<SeeOffChainNftScreen> createState() => _SeeOffChainNftScreenState();
}

const importProofText = 'Import proof from file';
const seeOffChainNftText = 'See all off-chain NFTs';
const idText = "id";
const urlText = "url";
const memoText = "memo";
const importText = "Import";

class _SeeOffChainNftScreenState extends State<SeeOffChainNftScreen> {
  String importedId = "";
  String importedUrl = "";
  String importedMemo = "";
  final List<String> availableNfts = [
    "Board Ape 1",
    "Board Ape 2",
    "Board Ape 3"
  ];
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
              importProofText,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                hintText: idText,
              ),
              onChanged: (value) => setState(() {
                importedId = value;
              }),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                hintText: urlText,
              ),
              onChanged: (value) => setState(() {
                importedUrl = value;
              }),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                hintText: memoText,
              ),
              onChanged: (value) => setState(() {
                importedMemo = value;
              }),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size.fromHeight(60),
              ),
              onPressed: () {},
              child: const Text(importText),
            ),
            const SizedBox(height: 20),
            const Text(
              seeOffChainNftText,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            listAvailableNFTs()
          ],
        ),
      ),
    );
  }

  Widget listAvailableNFTs() => SingleChildScrollView(
          child: Column(
        children: availableNfts.map(buildFile).toList(),
      ));

  Widget buildFile(String nftName) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            const Icon(Icons.text_snippet, size: 40, color: Colors.red),
            Text(nftName)
          ],
        ),
      );
}
