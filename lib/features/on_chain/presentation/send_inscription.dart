import 'package:bitcoin_nft_ui/features/on_chain/data/nft_getter.dart';
import 'package:bitcoin_nft_ui/features/on_chain/domain/nft_getter_domain.dart';
import 'package:bitcoin_nft_ui/features/on_chain/domain/send_inscription_domain.dart';
import 'package:bitcoin_nft_ui/features/on_chain/domain/upload_inscription_domain.dart';
import 'package:bitcoin_nft_ui/features/on_chain/presentation/fee_block_info.dart';
import 'package:bitcoin_nft_ui/features/on_chain/presentation/presentation_dialog.dart';
import 'package:bitcoin_nft_ui/features/settings/data/ui_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendInscriptionScreen extends StatefulWidget {
  const SendInscriptionScreen({super.key});

  @override
  State<SendInscriptionScreen> createState() => _SendInscriptionScreenState();
}

const chooseNftToSendText = "Step 1: Fetch NFT and choose NFT to send";
const fetchNftText = "Refresh";
const receiptAddressText = "Step 2: Type receipt address to transfer NFT";
const receiptAddressTextHint = "Receipt address";
const feeCalculationText = "Step 3: Estimate fee";
const calculateFeeText = "Calculate fee";
const submitTransactionText = "Step 4: Submit transaction";
const submitText = "Submit";

class _SendInscriptionScreenState extends State<SendInscriptionScreen> {
  String receiverAddress = "";
  NftStructure nftChoice =
      const NftStructure(hexData: "", mimeType: "", txId: "", originTxId: "");
  int feeValue = 0;

  Future<List<NftStructure>> fetchNftFuture = NftGetterDomain.nftGetterDomain();

  /* 
    UI Logic function with onA, onB, onC
  */
  void onFetchNft() async {
    setState(() {
      fetchNftFuture = NftGetterDomain.nftGetterDomain();
    });
  }

  void onSubmit(String passphrase) async {
    if (nftChoice.hexData.isNotEmpty && nftChoice.mimeType.isNotEmpty) {
      /*
        txIdRef = data.([]string)[0]
				originTxId := data.([]string)[1]
				dataSend = []byte(originTxId)
       */
      final result = await SendInscriptionDomain.sendInscriptionDomain(
          receiverAddress, passphrase, [nftChoice.txId, nftChoice.originTxId]);
      if (result.fee != -1) {
        // ignore: use_build_context_synchronously
        showSuccessfulDialogAboutCreatingInscription("Send inscription successfully", result, context);
      } else {
        // ignore: use_build_context_synchronously
        showFailedDialogAboutCreatingInscription(result, context);
      }
    }
  }

  void onCalculateFee(String passphrase) async {
    if (nftChoice.hexData.isNotEmpty && nftChoice.mimeType.isNotEmpty) {
      final result = await UploadInscriptionDomain.estimateFeeDomain(
          receiverAddress, passphrase, [nftChoice.originTxId], true);
      setState(() {
        feeValue = result;
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
                    //STEP 1
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
                          onPressed: onFetchNft,
                          child: const Text(fetchNftText),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    FutureBuilder<List<NftStructure>>(
                        future: fetchNftFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            return listAvailableNFTs(snapshot.data!, (struc) {
                              setState(() {
                                nftChoice = struc;
                              });
                            });
                          }
                          if (snapshot.hasError) {
                            return const Text("No connection!");
                          }
                          return const CircularProgressIndicator();
                        }),
                    const SizedBox(height: 20),
                    //STEP 2
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
                    const SizedBox(
                      height: 20,
                    ),
                    //STEP 3
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
                    const Text(
                      submitTransactionText,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  ],
                ),
              ),
            ));
  }

  Widget listAvailableNFTs(
          List<NftStructure> ls, Function(NftStructure) callback) =>
      SingleChildScrollView(
          child: Column(
        children: ls.map((e) => buildFile(e, callback)).toList(),
      ));

  Widget buildFile(NftStructure nftStruc, Function(NftStructure) callback) =>
      InkWell(
        onTap: () {
          callback(nftStruc);
        },
        child: Container(
          decoration: BoxDecoration(
              color: nftChoice.txId == nftStruc.txId
                  ? Colors.blue
                  : Colors.transparent,
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
