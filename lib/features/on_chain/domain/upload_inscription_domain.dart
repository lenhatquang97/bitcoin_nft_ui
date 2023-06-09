import 'dart:io';

import 'package:bitcoin_nft_ui/features/on_chain/data/upload_inscription.dart';
import 'package:convert/convert.dart';

class UploadInscriptionDomain {
  static Future<int> estimateFeeDomain(
      int numBlocks, int satoshiVal, String binaryHex) async {
    final req = UploadInscriptionRequest(
        address: "n1Nd8J38uyDRLwh5ShAAPvbNrqBD1wee8v",
        passphrase: "12345",
        amount: satoshiVal,
        isRef: false,
        urls: [binaryHex],
        numBlocks: numBlocks);
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

  static Future<UploadInscriptionResponse> uploadInscriptionDomain(int numBlocks, int satoshiVal, String binaryHex) async {
    final req = UploadInscriptionRequest(
        address: "n1Nd8J38uyDRLwh5ShAAPvbNrqBD1wee8v",
        passphrase: "12345",
        amount: satoshiVal,
        isRef: false,
        urls: [binaryHex],
        numBlocks: numBlocks);
    try {
      final res = await uploadInscription(req);
      return res;
    } catch (e) {
      return const UploadInscriptionResponse(revealTxId: "",commitTxId: "", fee: -1);
    }
  }
}
