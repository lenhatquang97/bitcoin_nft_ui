import 'package:bitcoin_nft_ui/features/on_chain/data/nft_getter.dart';
import 'package:bitcoin_nft_ui/features/on_chain/domain/nft_getter_domain.dart';
import 'package:bitcoin_nft_ui/features/settings/data/ui_settings.dart';
import 'package:bitcoin_nft_ui/ui/file_renderer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SeeYourNftScreen extends StatefulWidget {
  const SeeYourNftScreen({super.key});

  @override
  State<SeeYourNftScreen> createState() => _SeeYourNftScreenState();
}

const seeYourNftText = "Your NFT Collection";
const refreshText = "Refresh";

class _SeeYourNftScreenState extends State<SeeYourNftScreen> {
  void onRefresh() async {
    setState(() {
      nftGetterFuture = NftGetterDomain.nftGetterDomain();
    });
  }

  Future<List<NftStructure>> nftGetterFuture =
      NftGetterDomain.nftGetterDomain();

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
                          seeYourNftText,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: onRefresh,
                          child: const Text(refreshText),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    FutureBuilder<List<NftStructure>>(
                        future: nftGetterFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            if (snapshot.data != null &&
                                snapshot.data!.isEmpty) {
                              return const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 20),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Icon(Icons.close, size: 120),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    "Sorry, There are no NFTs",
                                    style: TextStyle(fontSize: 20),
                                  )
                                ],
                              );
                            }
                            return buildGrid(snapshot.data!);
                          } else if (snapshot.hasError) {
                            return const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.center,
                                  child: Icon(Icons.close, size: 120),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "Sorry, May be you meet an error!",
                                  style: TextStyle(fontSize: 20),
                                )
                              ],
                            );
                          }
                          return const CircularProgressIndicator();
                        })
                  ],
                ),
              ),
            ));
  }

  //Generate widget that displays grid of NFTs but no line space
  Widget buildGrid(List<NftStructure> data) => GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: data.map(buildFile).toList(),
      );

  Widget buildFile(NftStructure structure) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Align(
            //     alignment: Alignment.center,
            //     child: Icon(Icons.text_snippet, size: 120, color: Colors.red)),
            FileRendererWidget(
                hexStr: structure.hexData,
                mimeType: structure.mimeType,
                txId: structure.txId),
            const SizedBox(height: 20),
            Text("Transaction ID: ${structure.txId}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Expanded(
                child: Text("Original transaction ID: ${structure.originTxId}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold))),
          ],
        ),
      );
}
