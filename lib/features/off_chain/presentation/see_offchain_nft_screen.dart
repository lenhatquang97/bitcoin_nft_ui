import 'package:bitcoin_nft_ui/features/off_chain/data/offchain_nft_api.dart';
import 'package:bitcoin_nft_ui/features/off_chain/domain/import_proof_domain.dart';
import 'package:bitcoin_nft_ui/ui/web_renderer.dart';
import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
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
const urlText = "filePath";
const memoText = "memo";
const importText = "Import";
const refreshText = "Fetch off-chain NFTs";
const noNftText = "There are no NFTs here, please refresh to see your NFTs!";

class _SeeOffChainNftScreenState extends State<SeeOffChainNftScreen> {
  String importedId =  const Uuid().v1();
  XFile importedFilePath = XFile("");
  String importedMemo = "";
  Future<OffChainNftResponse> offChainFuture =
      ImportProofDomain.viewOffChainNfts();
  bool isLoading = false;

  void onImportProof() async {
    setState(() {
      isLoading = true;
    });
    final res = await ImportProofDomain.importProofDomain(
        importedId,
        "",
        importedMemo,
        importedFilePath.path);
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
      importedId = const Uuid().v1();
      isLoading = false;
    });
  }

  void onRefresh() async {
    setState(() {
      offChainFuture = ImportProofDomain.viewOffChainNfts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
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
                  : const Text(""),
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
                onPressed: onImportProof,
                child: isLoading ? const CircularProgressIndicator() : const Text(importText),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(60),
                ),
                onPressed: onRefresh,
                child: const Text(refreshText),
              ),
              const SizedBox(height: 20),
              FutureBuilder<OffChainNftResponse>(
                future: offChainFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return listAvailableNFTs(width, snapshot.data!);
                  } else if (snapshot.hasError) {
                    return const Text(
                      "Text error",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    );
                  }
                  return const CircularProgressIndicator();
                },
              )
            ]),
      ),
    );
  }

  Widget listAvailableNFTs(double width, OffChainNftResponse resp) =>
      SingleChildScrollView(
          child: resp.data.isNotEmpty
              ? GridView.count(
                  crossAxisCount: width < 900 ? 2 : 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: resp.data.map(buildFile).toList(),
                )
              : const Column(
                  children: [Text(noNftText)],
                ));

  Widget buildFile(OffChainNftStructure res) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: [
            WebRendererWidget(url: res.url, binary: res.binary),
            const SizedBox(height: 10),
            Flexible(child: Text(res.id, textAlign: TextAlign.center)),
            const SizedBox(height: 10),
            Flexible(
                child: Text(
              res.memo,
              textAlign: TextAlign.center,
            ))
          ],
        ),
      );
}
