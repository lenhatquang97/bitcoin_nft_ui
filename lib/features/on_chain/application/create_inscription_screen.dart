import 'package:bitcoin_nft_ui/features/on_chain/application/fee_block_info.dart';
import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const dropFileText = "Drop file here below";
const dropFileNote =
    "File can be any type of images, musics, videos but less than 3MB";
const uploadInscriptionText = "Upload your inscription";
const inscriptionNoteText =
    "Note that inscription can be viewed by anyone and they can be never changed or deleted";
const satoshiValue = "Set satoshi value for this inscription";
const satoshiValueTextHint = "Satoshi value";
const transactionFeeText = "Set your transaction fee";
const submitText = "Submit";

class CreateInscriptionScreen extends StatefulWidget {
  const CreateInscriptionScreen({super.key});

  @override
  State<CreateInscriptionScreen> createState() => _CreateInscriptionScreenState();
}

class _CreateInscriptionScreenState extends State<CreateInscriptionScreen> {
  final List<XFile> files = [];
  int satoshiVal = 0;
  int feeChoice = 0;

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
              uploadInscriptionText,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(inscriptionNoteText),
            const SizedBox(
              height: 20,
            ),
            DropTarget(
              onDragDone: (urls) => {
                setState(() {
                  files.addAll(urls.files);
                })
              },
              child: Container(
                color: Colors.blue,
                height: 200,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload_file_rounded,
                          size: 40, color: Colors.white),
                      SizedBox(height: 10),
                      Text(dropFileText, style: TextStyle(fontSize: 20)),
                      SizedBox(height: 10),
                      Text(dropFileNote)
                    ],
                  ),
                ),
              ),
            ),
            buildFiles(),
            const SizedBox(
              height: 20,
            ),
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
              transactionFeeText,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FeeBlockWidget(
                    feeTitle: "Normal fee",
                    feeRate: 1.0,
                    transactionSize: 100,
                    satoshiReceive: satoshiVal,
                    transactionFeeChoice: feeChoice,
                    feeNumber: 0,
                    voidCallback: () => setState(() {
                          feeChoice = 0;
                        })),
                FeeBlockWidget(
                  feeTitle: "Middle fee",
                  feeRate: 1.5,
                  transactionSize: 100,
                  satoshiReceive: satoshiVal,
                  transactionFeeChoice: feeChoice,
                  feeNumber: 1,
                  voidCallback: () => setState(() {
                    feeChoice = 1;
                  }),
                ),
                FeeBlockWidget(
                    feeTitle: "Higher fee",
                    feeRate: 2.0,
                    transactionSize: 100,
                    satoshiReceive: satoshiVal,
                    transactionFeeChoice: feeChoice,
                    feeNumber: 2,
                    voidCallback: () => setState(() {
                          feeChoice = 2;
                        })),
              ],
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size.fromHeight(60),
              ),
              onPressed: () {},
              child: const Text(submitText),
            )
          ],
        ),
      ),
    );
  }

  Widget buildFiles() => SingleChildScrollView(
          child: Column(
        children: files.map(buildFile).toList(),
      ));

  Widget buildFile(XFile file) => ListTile(
        leading: const SizedBox(
          width: 60,
          child: Icon(Icons.text_snippet, size: 40, color: Colors.red),
        ),
        title: Text(file.path),
      );
}
