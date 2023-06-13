import 'package:bitcoin_nft_ui/features/on_chain/data/nft_getter.dart';
import 'package:bitcoin_nft_ui/features/on_chain/domain/nft_getter_domain.dart';
import 'package:bitcoin_nft_ui/features/on_chain/domain/send_inscription_domain.dart';
import 'package:bitcoin_nft_ui/features/on_chain/domain/upload_inscription_domain.dart';
import 'package:bitcoin_nft_ui/features/on_chain/presentation/fee_block_info.dart';
import 'package:bitcoin_nft_ui/features/on_chain/presentation/presentation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SendInscriptionScreen extends StatefulWidget {
  const SendInscriptionScreen({super.key});

  @override
  State<SendInscriptionScreen> createState() => _SendInscriptionScreenState();
}

const chooseNftToSendText = "Step 1: Fetch NFT and choose NFT to send";
const fetchNftText = "Fetch NFT";
const receiptAddressText = "Step 2: Type receipt address to transfer NFT";
const receiptAddressTextHint = "Receipt address";
const typeSatoshiText = "Step 3: Type satoshi for keeping NFT";
const satoshiNumberTextHint = "Must be number";
const feeCalculationText = "Step 4: Estimate fee and modify satoshi";
const calculateFeeText = "Calculate fee";
const submitTransactionText = "Step 5: Submit transaction";
const submitText = "Submit";
class _SendInscriptionScreenState extends State<SendInscriptionScreen> {
  String receiverAddress = "";
  int nftChoice = -1;
  int feeValue = 0;
  int satoshiVal = 0;
  List<NftStructure> availableNfts = [];

  /* 
    UI Logic function with onA, onB, onC
  */
  void onFetchNft() async {
    final value = await NftGetterDomain.nftGetterDomain(
        "n1Nd8J38uyDRLwh5ShAAPvbNrqBD1wee8v");
    setState(() {
      availableNfts = value;
    });
  }

  void onSubmit() async {
    if (availableNfts.isNotEmpty) {
      const passphrase = "12345";
      final txId = availableNfts[nftChoice].txId;
      final result = await SendInscriptionDomain.sendInscriptionDomain(
          receiverAddress, passphrase, satoshiVal, txId);
      if (result.fee != -1) {
        // ignore: use_build_context_synchronously
        showSuccessfulDialogAboutCreatingInscription(result, context);
      } else {
        // ignore: use_build_context_synchronously
        showFailedDialogAboutCreatingInscription(result, context);
      }
    }
  }

  void onCalculateFee() async {
    if (availableNfts.isNotEmpty) {
      const passphrase = "12345";
      final txId = availableNfts[nftChoice].txId;
      final result = await UploadInscriptionDomain.estimateFeeDomain(
          receiverAddress, passphrase, 1, satoshiVal, [txId], true);
      setState(() {
        feeValue = result;
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
            //STEP 1
            const Text(
              chooseNftToSendText,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            listAvailableNFTs(nftChoice, (ind) {
              setState(() {
                nftChoice = ind;
              });
            }),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size.fromHeight(60),
              ),
              onPressed: onFetchNft,
              child: const Text(fetchNftText),
            ),
            const SizedBox(height: 20),
            //STEP 2
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
            const SizedBox(
              height: 20,
            ),
            //STEP 3
            const Text(
              typeSatoshiText,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                hintText: satoshiNumberTextHint,
              ),
              onChanged: (value) => setState(() {
                if (value.isNotEmpty) {
                  satoshiVal = int.parse(value);
                }
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
                FeeBlockWidget(
                    feeValue: feeValue,
                    satoshiReceive: satoshiVal),
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
            const Text(
              submitTransactionText,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
          ],
        ),
      ),
    );
  }

  Widget listAvailableNFTs(int nftChoice, Function(int) callback) =>
      SingleChildScrollView(
          child: Column(
        children: availableNfts
            .asMap()
            .entries
            .map((e) => buildFile(e.value, e.key, nftChoice, callback))
            .toList(),
      ));

  Widget buildFile(NftStructure nftStruc, int index, int currentIndex,
          Function(int) callback) =>
      InkWell(
        onTap: () {
          callback(index);
        },
        child: Container(
          decoration: BoxDecoration(
              color: currentIndex == index ? Colors.blue : Colors.transparent,
              borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.text_snippet, size: 40, color: Colors.red),
                const SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nftStruc.txId),
                    const SizedBox(height: 5),
                    Text(nftStruc.mimeType)
                  ],
                )
              ],
            ),
          ),
        ),
      );
}
