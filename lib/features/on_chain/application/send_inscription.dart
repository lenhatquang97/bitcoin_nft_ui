import 'package:flutter/material.dart';

class SendInscriptionScreen extends StatefulWidget {
  const SendInscriptionScreen({super.key});

  @override
  State<SendInscriptionScreen> createState() => _SendInscriptionScreenState();
}

const chooseNftToSendText = "Choose NFT to send";
const receiptAddressText = "Input receipt address";
const receiptAddressTextHint = "Receipt address";

class _SendInscriptionScreenState extends State<SendInscriptionScreen> {
  String receiverAddress = "";

  final List<String> availableNfts = ["Board Ape 1", "Board Ape 2", "Board Ape 3"];
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
            const SizedBox(height: 20,),
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
              onPressed: () {},
              child: const Text("Submit"),
            )
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