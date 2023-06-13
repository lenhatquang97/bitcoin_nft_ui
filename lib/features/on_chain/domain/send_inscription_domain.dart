import 'package:bitcoin_nft_ui/features/on_chain/data/send_inscription.dart';
import 'package:bitcoin_nft_ui/features/on_chain/data/upload_inscription.dart';

class SendInscriptionDomain{
  static Future<InscriptionResponse> sendInscriptionDomain(String address, String passphrase, int satoshiVal, String txId) async {
    final req = InscriptionRequest(
        address: address,
        passphrase: passphrase,
        isRef: true,
        isSendNft: true,
        numBlocks: 1,
        amount: satoshiVal,
        urls: [txId]);
    try {
      final res = await sendInscription(req);
      return res;
    } catch (e) {
      return const InscriptionResponse(revealTxId: "",commitTxId: "", fee: -1);
    }
  }
}