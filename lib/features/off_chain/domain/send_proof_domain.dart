import 'dart:developer';

import 'package:bitcoin_nft_ui/features/on_chain/data/send_inscription.dart';
import 'package:bitcoin_nft_ui/features/on_chain/data/upload_inscription.dart';

class SendProofDomain{
  static Future<SendResponse> sendDomain(String address, String passphrase, List<String> urls, String specialTxId, List<String> offChainData) async {
    final req = InscriptionRequest(
        address: address,
        passphrase: passphrase,
        isSendNft: true,
        isRef: true,
        onChainData: urls,
        isMint: false,
        txId: specialTxId,
        offChainData: offChainData
        );
    try {
      log(offChainData.toString());
      final res = await sendInscription(req);
      return res;
    } catch (e) {
      return const SendResponse(revealTxId: "",commitTxId: "", fee: -1);
    }
  }
}