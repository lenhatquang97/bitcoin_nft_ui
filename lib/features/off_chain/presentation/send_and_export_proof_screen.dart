import 'package:bitcoin_nft_ui/features/off_chain/data/export_proof_api.dart';
import 'package:bitcoin_nft_ui/features/off_chain/data/offchain_nft_api.dart';
import 'package:bitcoin_nft_ui/features/off_chain/domain/import_proof_domain.dart';
import 'package:bitcoin_nft_ui/features/off_chain/domain/send_proof_domain.dart';
import 'package:bitcoin_nft_ui/features/on_chain/domain/upload_inscription_domain.dart';
import 'package:bitcoin_nft_ui/features/on_chain/presentation/fee_block_info.dart';
import 'package:bitcoin_nft_ui/features/on_chain/presentation/presentation_dialog.dart';
import 'package:bitcoin_nft_ui/features/settings/data/ui_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendAndExportProofScreen extends StatefulWidget {
  const SendAndExportProofScreen({super.key});

  @override
  State<SendAndExportProofScreen> createState() =>
      _SendAndExportProofScreenState();
}

const sendAndExportProofText = 'Send and export proof';
const chooseNftToSendText = "Step 1: Choose multiple NFTs to send";
const receiptAddressText = "Step 2: Input receipt address";
const receiptAddressTextHint = "Receipt address";
const urlToExportText = "URL to export";
const exportProofStepText = "Step 4: Export proof";
const exportProofText = "Export proof";
const submitText = "Submit";
const outputText = "Output";
const outputNoteText = "Please copy this proof into another place";
const feeCalculationText = "Step 3: Estimate fee and submit";
const calculateFeeText = "Calculate fee";
const refreshText = "Refresh";

class _SendAndExportProofScreenState extends State<SendAndExportProofScreen> {
  String receiverAddress = "";
  String urlToExport = "";
  ExportProofResponse showedRes =
      const ExportProofResponse(id: "", url: "", memo: "");
  int feeValue = 0;

  Future<OffChainNftResponse> offChainFuture =
      ImportProofDomain.viewOffChainNfts();
  final List<OffChainNftStructure> multipleChoices = [];

  void onFetchOffChainNfts() async {
    setState(() {
      offChainFuture = ImportProofDomain.viewOffChainNfts();
      multipleChoices.clear();
    });
  }

  void onSubmit(String passphrase) async {
    if (multipleChoices.isNotEmpty) {
      final chosenNfts = multipleChoices.map((e) => e.url).toList();
      final result = await SendProofDomain.sendDomain(
          receiverAddress, passphrase, chosenNfts);
      if (result.fee != -1) {
        // ignore: use_build_context_synchronously
        showSuccessfulDialogAboutCreatingInscription("Send off-chain sucessfully", result, context);
      } else {
        // ignore: use_build_context_synchronously
        showFailedDialogAboutCreatingInscription(result, context);
      }
    }
  }

  void onCalculateFee(String passphrase) async {
    if (multipleChoices.isNotEmpty) {
      final chosenNfts = multipleChoices.map((e) => e.url).toList();
      final result = await UploadInscriptionDomain.estimateFeeDomain(
          receiverAddress, passphrase, chosenNfts, false);
      setState(() {
        feeValue = result;
      });
    }
  }

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
    return Consumer<UiSettings>(
        builder: (context, value, child) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          chooseNftToSendText,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: onFetchOffChainNfts,
                          child: const Text(refreshText),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    //Render NFT
                    FutureBuilder<OffChainNftResponse>(
                      future: offChainFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if(snapshot.data!.data.isEmpty){
                            return const Text("There are no NFTs here");
                          }
                          return listAvailableNFTs(snapshot.data!);
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        }
                        return const CircularProgressIndicator();
                      },
                    ),
                    const SizedBox(height: 10),

                    const Text(
                      receiptAddressText,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    //STEP 4
                    const Text(
                      feeCalculationText,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      onPressed: () {
                        onCalculateFee(value.passphrase);
                      },
                      child: const Text(calculateFeeText),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(60),
                      ),
                      onPressed: () {
                        onSubmit(value.passphrase);
                      },
                      child: const Text(submitText),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      exportProofStepText,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(outputNoteText),
                    const SizedBox(height: 20),
                    showedRes.id.isNotEmpty
                        ? SelectableText(showedRes.id)
                        : const Text(""),
                    const SizedBox(height: 20),
                    showedRes.url.isNotEmpty
                        ? SelectableText(showedRes.url)
                        : const Text(""),
                    const SizedBox(height: 20),
                    showedRes.memo.isNotEmpty
                        ? SelectableText(showedRes.memo)
                        : const Text(""),
                  ],
                ),
              ),
            ));
  }

  Widget listAvailableNFTs(OffChainNftResponse resp) => SingleChildScrollView(
          child: Column(
        children: resp.data
            .asMap()
            .entries
            .map((e) => buildFile(e.value, e.key))
            .toList(),
      ));

  Widget buildFile(OffChainNftStructure nftStruc, int index) => InkWell(
        onTap: () {
          setState(() {
            bool hasUrl =
                multipleChoices.any((element) => element.url == nftStruc.url);
            if (hasUrl) {
              multipleChoices
                  .removeWhere((element) => element.url == nftStruc.url);
            } else {
              multipleChoices.add(nftStruc);
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Container(
            decoration: BoxDecoration(
              color: (multipleChoices
                      .any((element) => element.url == nftStruc.url))
                  ? Colors.blue
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.text_snippet, size: 40, color: Colors.red),
                Text(nftStruc.id)
              ],
            ),
          ),
        ),
      );
}
