import 'package:bitcoin_nft_ui/features/off_chain/data/export_proof_api.dart';
import 'package:bitcoin_nft_ui/features/off_chain/domain/import_proof_domain.dart';
import 'package:flutter/material.dart';

class SendAndExportProofScreen extends StatefulWidget {
  const SendAndExportProofScreen({super.key});

  @override
  State<SendAndExportProofScreen> createState() =>
      _SendAndExportProofScreenState();
}

const sendAndExportProofText = 'Send and export proof';
const chooseNftToSendText = "Choose multiple NFTs to send";
const receiptAddressText = "Input receipt address";
const receiptAddressTextHint = "Receipt address";
const urlToExportText = "URL to export";
const exportProofText = "Export proof";
const submitText = "Submit";
const outputText = "Output";

class _SendAndExportProofScreenState extends State<SendAndExportProofScreen> {
  String receiverAddress = "";
  String urlToExport = "";
  ExportProofResponse showedRes =
      const ExportProofResponse(id: "", url: "", memo: "");

  final List<String> availableNfts = [
    "Board Ape 1",
    "Board Ape 2",
    "Board Ape 3"
  ];

  void onSubmit() async {}

  void onExportProof() async {
    final res = await ImportProofDomain.exportProofDomain(urlToExport);
    if (res.id.isNotEmpty) {
      setState(() {
        showedRes = res;
      });
    }
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
              chooseNftToSendText,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            //Render NFT
            listAvailableNFTs(),
            const SizedBox(height: 20),
            const Text(
              receiptAddressText,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: receiptAddressTextHint,
              ),
              onChanged: (value) => setState(() {
                receiverAddress = value;
              }),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size.fromHeight(60),
              ),
              onPressed: onSubmit,
              child: const Text(submitText),
            ),
            const SizedBox(height: 20),
            const Text(
              exportProofText,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: urlToExportText,
              ),
              onChanged: (value) => setState(() {
                urlToExport = value;
              }),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size.fromHeight(60),
              ),
              onPressed: onExportProof,
              child: const Text(exportProofText),
            ),
            const SizedBox(height: 20),
            const Text(
              outputText,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            showedRes.id.isNotEmpty ? Text(showedRes.id) : const Text(""),
            const SizedBox(height: 20),
            showedRes.url.isNotEmpty ? Text(showedRes.url) : const Text(""),
            const SizedBox(height: 20),
            showedRes.memo.isNotEmpty ? Text(showedRes.memo) : const Text(""),
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
