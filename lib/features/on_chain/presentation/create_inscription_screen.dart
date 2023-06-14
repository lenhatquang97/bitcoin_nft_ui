import 'package:bitcoin_nft_ui/features/on_chain/domain/upload_inscription_domain.dart';
import 'package:bitcoin_nft_ui/features/on_chain/presentation/fee_block_info.dart';
import 'package:bitcoin_nft_ui/features/on_chain/presentation/presentation_dialog.dart';
import 'package:bitcoin_nft_ui/features/settings/data/ui_settings.dart';
import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

const dropFileText = "Drop file here below";
const dropFileNote =
    "File can be any type of images, musics, videos but less than 3MB";
const uploadInscriptionText = "Upload your inscription";
const inscriptionNoteText =
    "Note that inscription can be viewed by anyone and they can be never changed or deleted";
const satoshiValue = "Set satoshi value for this inscription";
const satoshiNoteText =
    "Note that this satoshi value is used for next transaction if you want to transfer NFT to other people";
const satoshiValueTextHint = "Satoshi value";
const transactionFeeText = "Set your transaction fee";
const transactionFeeNoteText = "You need to estimate fee before submitting to the chain.";
const submitText = "Submit";
const estimateFeeText = "Estimate fee";

class CreateInscriptionScreen extends StatefulWidget {
  const CreateInscriptionScreen({super.key});

  @override
  State<CreateInscriptionScreen> createState() =>
      _CreateInscriptionScreenState();
}

class _CreateInscriptionScreenState extends State<CreateInscriptionScreen> {
  //Note: This list is one value
  final List<XFile> files = [];
  int feeValue = 0;
  int satoshiVal = 0;
  int feeChoice = 0;

  /* 
    UI Logic function with onA, onB, onC
  */
  void onEstimateFee(String baseAddress, String passphrase) async {
    if (files.isNotEmpty) {
      final hexBinaryFile =
          await UploadInscriptionDomain.readBinaryFileDomain(files[0].path);
      final highFee = await UploadInscriptionDomain.estimateFeeDomain(
          baseAddress, passphrase, 1, satoshiVal, [hexBinaryFile], false);
      setState(() {
        feeValue = highFee;
      });
    }
  }

  void onSubmit(String addr, String pass) async {
    final res = await UploadInscriptionDomain.uploadInscriptionDomain(addr, pass,
        feeChoice + 1, satoshiVal, files[0].path);
    if (res.fee != -1) {
      // ignore: use_build_context_synchronously
      showSuccessfulDialogAboutCreatingInscription(res, context);
    } else {
      // ignore: use_build_context_synchronously
      showFailedDialogAboutCreatingInscription(res, context);
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
            //STEP 1
            const Text(
              uploadInscriptionText,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(inscriptionNoteText),
            const SizedBox(
              height: 20,
            ),
            DropTarget(
              onDragDone: (urls) => {
                setState(() {
                  if (files.isEmpty) {
                    files.add(urls.files[0]);
                  } else {
                    files[0] = urls.files[0];
                  }
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
                      Text(dropFileText, style: TextStyle(fontSize: 20)),
                      SizedBox(height: 10),
                      Text(dropFileNote)
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            buildFiles(),
            const SizedBox(
              height: 20,
            ),

            //STEP 2
            const Text(
              satoshiValue,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(satoshiNoteText),

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
            //STEP 3
            const Text(
              transactionFeeText,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(transactionFeeNoteText),
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
                onEstimateFee(value.yourAddress, value.passphrase);
              },
              child: const Text(estimateFeeText),
            ),
            const SizedBox(
              height: 20,
            ),

            //STEP 4
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size.fromHeight(60),
              ),
              onPressed: (){
                onSubmit(value.yourAddress, value.passphrase);
              },
              child: const Text(submitText),
            )
          ],
        ),
      ),
    ));
  }

  Widget buildFiles() => Column(
        children: files.map(buildFile).toList(),
      );

  Widget buildFile(XFile file) => ListTile(
        leading: const SizedBox(
          width: 40,
          child: Icon(Icons.text_snippet, size: 40, color: Colors.red),
        ),
        title: Text(file.path),
      );
}
