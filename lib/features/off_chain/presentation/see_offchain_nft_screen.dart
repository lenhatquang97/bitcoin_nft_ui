import 'package:bitcoin_nft_ui/features/off_chain/domain/import_proof_domain.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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
  TextEditingController importedIdController = TextEditingController(text: const Uuid().v1());
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
              controller: importedIdController,
              decoration: const InputDecoration(
                hintText: idText,
              ),
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
              onPressed: () async{
                final res = await ImportProofDomain.importProofDomain(importedIdController.value.text, importedUrl, importedMemo);
                if (res == 200) {
                    var snackBar = const SnackBar(content: Text('Success'));
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                    var snackBar = SnackBar(content: Text('Failure with error code $res'));
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                setState(() {
                  importedIdController.text = const Uuid().v1();
                });
              },
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
