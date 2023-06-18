import 'package:bitcoin_nft_ui/features/off_chain/data/mint_off_chain_api.dart';
import 'package:bitcoin_nft_ui/features/off_chain/domain/import_proof_domain.dart';
import 'package:bitcoin_nft_ui/features/off_chain/domain/mint_nft_domain.dart';
import 'package:bitcoin_nft_ui/features/on_chain/domain/upload_inscription_domain.dart';
import 'package:bitcoin_nft_ui/features/on_chain/presentation/fee_block_info.dart';
import 'package:bitcoin_nft_ui/features/on_chain/presentation/presentation_dialog.dart';
import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ImportOffChainNftScreen extends StatefulWidget {
  const ImportOffChainNftScreen({super.key});

  @override
  State<ImportOffChainNftScreen> createState() =>
      _ImportOffChainNftScreenState();
}

const importProofText = 'Mint an NFT by dragging file below';
const seeOffChainNftText = 'See all off-chain NFTs';
const memoText = "Memo";
const calculateFeeText = "Calculate fee";
const mintText = "Mint now";

const importNftText = "Import new NFT into the database after confirmation";
const importText = "Import";

class _ImportOffChainNftScreenState extends State<ImportOffChainNftScreen> {
  //Global state
  bool isLoading = false;

  //Mint new NFT
  String mintedMemo = "";
  XFile importedFilePath = XFile("");
  OCDataRequest mintValue = const OCDataRequest(id: "", url: "", memo: "");
  //Mint function
  void onMint() async {
    final res = await MintNftDomain.mintNftOffChainDomain(
        const Uuid().v1(), mintedMemo, importedFilePath.path);
    if (res.$1.id.isNotEmpty) {
      setState(() {
        mintValue = res.$1;
      });
      showSuccessfulDialogAboutCreatingInscription(
          "Mint off-chain NFT successfully", res.$2, context);
    } else {
      showFailedDialogAboutCreatingInscription(res.$2, context);
    }
  }

  //Import new NFT
  String typedId = "";
  String typedUrl = "";
  String typedMemo = "";
  //Import function
  void onImportProof() async {
    setState(() {
      isLoading = true;
    });
    final res =
        await ImportProofDomain.importProofDomain(typedId, typedUrl, typedMemo);
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
      isLoading = false;
    });
  }

  //Calculate fee
  int feeValue = 0;
  void onCalculateFee() async {
    final result = await UploadInscriptionDomain.estimateFeeDomain(
        "default", "12345", ["www.google.com"], false);
    setState(() {
      feeValue = result;
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
                importProofText,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              DropTarget(
                onDragDone: (urls) => {
                  setState(() {
                    importedFilePath = urls.files[0];
                  })
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(16)),
                  height: 150,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file_rounded,
                            size: 30, color: Colors.white),
                        SizedBox(height: 10),
                        Text("Drop file here below",
                            style: TextStyle(fontSize: 20))
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              importedFilePath.path.isNotEmpty
                  ? Text(importedFilePath.path,
                      style: const TextStyle(fontWeight: FontWeight.bold))
                  : const SizedBox(height: 0),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: memoText,
                ),
                onChanged: (value) => setState(() {
                  mintedMemo = value;
                }),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FeeBlockWidget(feeValue: feeValue),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(60),
                ),
                onPressed: onCalculateFee,
                child: const Text(calculateFeeText),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(60),
                ),
                onPressed: onMint,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text(mintText),
              ),
              const SizedBox(height: 15),
              mintValue.id.isNotEmpty
                  ? SelectableText(
                      "${mintValue.id}\n${mintValue.url}\n${mintValue.memo}",
                      style: const TextStyle(fontSize: 20),
                    )
                  : const SizedBox(height: 0),
              const SizedBox(height: 15),
              const Text(
                importNftText,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "ID",
                ),
                onChanged: (value) => setState(() {
                  typedId = value;
                }),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "URL",
                ),
                onChanged: (value) => setState(() {
                  typedUrl = value;
                }),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Memo",
                ),
                onChanged: (value) => setState(() {
                  typedMemo = value;
                }),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(60),
                ),
                onPressed: onImportProof,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text(importText),
              ),
            ]),
      ),
    );
  }
}
