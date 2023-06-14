import 'package:bitcoin_nft_ui/features/off_chain/data/export_proof_api.dart';
import 'package:bitcoin_nft_ui/features/off_chain/data/offchain_nft_api.dart';
import 'package:bitcoin_nft_ui/features/off_chain/domain/import_proof_domain.dart';
import 'package:bitcoin_nft_ui/features/off_chain/domain/send_proof_domain.dart';
import 'package:bitcoin_nft_ui/features/on_chain/domain/upload_inscription_domain.dart';
import 'package:bitcoin_nft_ui/features/on_chain/presentation/fee_block_info.dart';
import 'package:bitcoin_nft_ui/features/on_chain/presentation/presentation_dialog.dart';
import 'package:bitcoin_nft_ui/features/settings/data/ui_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SendAndExportProofScreen extends StatefulWidget {
  const SendAndExportProofScreen({super.key});

  @override
  State<SendAndExportProofScreen> createState() =>
      _SendAndExportProofScreenState();
}

const sendAndExportProofText = 'Send and export proof';
const chooseNftToSendText = "Step 1: Choose multiple NFTs to send";
const receiptAddressText = "Step 3: Input receipt address";
const receiptAddressTextHint = "Receipt address";
const urlToExportText = "URL to export";
const exportProofStepText = "Step 5: Export proof";
const exportProofText = "Export proof";
const submitText = "Submit";
const outputText = "Output";
const outputNoteText = "Please copy this proof into another place";
const feeCalculationText = "Step 4: Estimate fee, modify satoshi and submit";
const calculateFeeText = "Calculate fee";
const satoshiValue = "Step 2: Set satoshi value for off-chain NFT";
const satoshiValueTextHint = "Satoshi value";
const refreshText = "Fetch off-chain NFTs";

class _SendAndExportProofScreenState extends State<SendAndExportProofScreen> {
  String receiverAddress = "";
  String urlToExport = "";
  ExportProofResponse showedRes =
      const ExportProofResponse(id: "", url: "", memo: "");
  int feeValue = 0;
  int satoshiVal = 0;

  final List<OffChainNftStructure> availableNfts = [];
  final List<bool> multipleChoices = [];

  void onFetchOffChainNfts() async {
    final res = await ImportProofDomain.viewOffChainNfts();
    if (res.data.isNotEmpty) {
      setState(() {
        availableNfts.clear();
        availableNfts.addAll(res.data);
        multipleChoices.clear();
        multipleChoices.addAll(List<bool>.filled(res.data.length, false));
      });
    }
  }

  void onSubmit(String passphrase) async {
    if (availableNfts.isNotEmpty) {
      final chosenNfts = availableNfts
          .asMap()
          .entries
          .where((e) => e.key < availableNfts.length && multipleChoices[e.key])
          .map((e) => e.value.url)
          .toList();
      final result = await SendProofDomain.sendDomain(
          receiverAddress, passphrase, satoshiVal, chosenNfts);
      if (result.fee != -1) {
        // ignore: use_build_context_synchronously
        showSuccessfulDialogAboutCreatingInscription(result, context);
      } else {
        // ignore: use_build_context_synchronously
        showFailedDialogAboutCreatingInscription(result, context);
      }
    }
  }

  void onCalculateFee(String passphrase) async {
    if (availableNfts.isNotEmpty) {
      final chosenNfts = availableNfts
          .asMap()
          .entries
          .where((e) => e.key < availableNfts.length && multipleChoices[e.key])
          .map((e) => e.value.url)
          .toList();
      final result = await UploadInscriptionDomain.estimateFeeDomain(
          receiverAddress, passphrase, 1, satoshiVal, chosenNfts, false);
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
    return Consumer<UiSettings>(builder: (context, value, child) => Padding(
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
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size.fromHeight(60),
              ),
              onPressed: onFetchOffChainNfts,
              child: const Text(refreshText),
            ),
            const SizedBox(height: 20),
            const Text(
              satoshiValue,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                hintText: satoshiValueTextHint,
              ),
              onChanged: (value) => setState(() {
                if (value.isNotEmpty) {
                  satoshiVal = int.parse(value);
                }
              }),
            ),
            const SizedBox(height: 20),
            const Text(
              receiptAddressText,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FeeBlockWidget(feeValue: feeValue, satoshiReceive: satoshiVal),
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
            const SizedBox(height: 10),
            const Text(outputNoteText),
            const SizedBox(height: 20),
            showedRes.id.isNotEmpty ? SelectableText(showedRes.id) : const Text(""),
            const SizedBox(height: 20),
            showedRes.url.isNotEmpty ? SelectableText(showedRes.url) : const Text(""),
            const SizedBox(height: 20),
            showedRes.memo.isNotEmpty ? SelectableText(showedRes.memo) : const Text(""),
          ],
        ),
      ),
    ));
  }

  Widget listAvailableNFTs() => SingleChildScrollView(
          child: Column(
        children: availableNfts
            .asMap()
            .entries
            .map((e) => buildFile(e.value, e.key))
            .toList(),
      ));

  Widget buildFile(OffChainNftStructure nftStruc, int index) => InkWell(
        onTap: () {
          setState(() {
            if (index < multipleChoices.length) {
              multipleChoices[index] = !multipleChoices[index];
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Container(
            decoration: BoxDecoration(
              color: (index < multipleChoices.length && multipleChoices[index])
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
