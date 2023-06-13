import 'package:bitcoin_nft_ui/features/on_chain/data/send_inscription.dart';
import 'package:bitcoin_nft_ui/features/on_chain/data/upload_inscription.dart';

class SendProofDomain{
  static Future<InscriptionResponse> sendDomain(String address, String passphrase, int satoshiVal, List<String> urls) async {
    final req = InscriptionRequest(
        address: address,
        passphrase: passphrase,
        isRef: true,
        isSendNft: true,
        numBlocks: 1,
        amount: satoshiVal,
        urls: urls);
    try {
      final res = await sendInscription(req);
      return res;
    } catch (e) {
      return const InscriptionResponse(revealTxId: "",commitTxId: "", fee: -1);
    }
  }
}