import 'package:bitcoin_nft_ui/features/off_chain/data/view_offchain_nft_api.dart';
import 'package:bitcoin_nft_ui/features/off_chain/domain/import_proof_domain.dart';
import 'package:bitcoin_nft_ui/ui/web_renderer.dart';
import 'package:flutter/material.dart';

class ViewOffChainNftScreen extends StatefulWidget {
  const ViewOffChainNftScreen({super.key});

  @override
  State<ViewOffChainNftScreen> createState() => _ViewOffChainNftScreenState();
}

const refreshText = "Fetch off-chain NFTs";
const noNftText = "There are no NFTs here, please refresh to see your NFTs!";

class _ViewOffChainNftScreenState extends State<ViewOffChainNftScreen> {
  Future<OffChainNftResponse> offChainFuture =
      ImportProofDomain.viewOffChainNfts();

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
            Text(
              res.txId,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              res.memo,
              textAlign: TextAlign.center,
            )

          ],
        ),
      );
}
