import 'package:bitcoin_nft_ui/features/on_chain/data/send_inscription.dart';
import 'package:bitcoin_nft_ui/features/on_chain/data/upload_inscription.dart';

class SendProofDomain{
  static Future<InscriptionResponse> sendDomain(String address, String passphrase, List<String> urls) async {
    final req = InscriptionRequest(
        address: address,
        passphrase: passphrase,
        isSendNft: true,
        isRef: true,
        urls: urls);
    try {
      final res = await sendInscription(req);
      return res;
    } catch (e) {
      return const InscriptionResponse(revealTxId: "",commitTxId: "", fee: -1);
    }
  }
}