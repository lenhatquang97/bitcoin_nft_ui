import 'package:flutter/material.dart';

class SeeYourNftScreen extends StatefulWidget {
  const SeeYourNftScreen({super.key});

  @override
  State<SeeYourNftScreen> createState() => _SeeYourNftScreenState();
}

const seeYourNftText = "See your NFTs";

class _SeeYourNftScreenState extends State<SeeYourNftScreen> {
  final List<String> availableNfts = [
    "Board Ape 1",
    "Board Ape 2",
    "Board Ape 3",
    "Board Ape 4",
    "Board Ape 1",
    "Board Ape 2",
    "Board Ape 3",
    "Board Ape 4"
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
              seeYourNftText,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            buildGrid()
          ],
        ),
      ),
    );
  }

  //Generate widget that displays grid of NFTs but no line space
  Widget buildGrid() => GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: availableNfts.map(buildFile).toList(),
      );

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
