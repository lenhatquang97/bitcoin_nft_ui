import 'package:bitcoin_nft_ui/features/off_chain/data/mint_off_chain_api.dart';
import 'package:bitcoin_nft_ui/features/on_chain/data/send_inscription.dart';
import 'package:bitcoin_nft_ui/features/on_chain/data/upload_inscription.dart';

class MintNftDomain {
  static Future<(OCDataRequest, SendResponse)> mintNftOffChainDomain(String id, String memo, String filePath) async {
    final ipfsLink = await getIpfsLink(id, memo, filePath);
    final req = InscriptionRequest(
        address: "default",
        passphrase: "12345",
        isSendNft: true,
        isRef: false,
        isMint: true,
        onChainData: [],
        txId: "",
        offChainData: [id, ipfsLink, memo]
        );
    final res = await sendInscription(req);
    return (OCDataRequest(id: id, url: ipfsLink, memo: memo), res);
  }
}