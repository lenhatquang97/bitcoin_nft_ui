import 'dart:io';

import 'package:bitcoin_nft_ui/features/on_chain/data/upload_inscription.dart';
import 'package:convert/convert.dart';

class UploadInscriptionDomain {
  static Future<int> estimateFeeDomain(String address, String passphrase, List<String> data, bool isRef) async {
    final req = InscriptionRequest(
        address: address,
        passphrase: passphrase,
        isRef: isRef,
        onChainData: data,
        isSendNft: true,
        isMint: true,
        txId: "",
        offChainData: []
        );
    try {
      final res = await estimateFee(req);
      return res;
    } catch (e) {
      return -1;
    }
  }
  static Future<String> readBinaryFileDomain(String path) async {
    //Give a path and read file as binary and convert to hex string in each phase
    final file = File(path);
    final bytes = await file.readAsBytes();
    final hexStr = hex.encode(bytes);
    return hexStr;
  }

  static Future<SendResponse> uploadInscriptionDomain(String pass, String filePath) async {
    final req = InscriptionRequest(
        address: "default",
        passphrase: pass,
        isRef: false,
        isSendNft: true,
        onChainData: [filePath],
        isMint: true,
        txId: "",
        offChainData: []
        );
    try {
      final res = await uploadInscription(req);
      return res;
    } catch (e) {
      return const SendResponse(revealTxId: "",commitTxId: "", fee: -1);
    }
  }
}
