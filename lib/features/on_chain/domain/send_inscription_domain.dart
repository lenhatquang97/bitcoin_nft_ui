import 'package:bitcoin_nft_ui/features/on_chain/data/send_inscription.dart';
import 'package:bitcoin_nft_ui/features/on_chain/data/upload_inscription.dart';

class SendInscriptionDomain{
  static Future<SendResponse> sendInscriptionDomain(String address, String passphrase, List<String> data) async {
    final req = InscriptionRequest(
        address: address,
        passphrase: passphrase,
        isRef: true,
        isSendNft: true,
        urls: data,
        isMint: true,
        txId: ""
        );
    try {
      final res = await sendInscription(req);
      return res;
    } catch (e) {
      return const SendResponse(revealTxId: "",commitTxId: "", fee: -1);
    }
  }
}