import 'dart:convert';
import 'dart:developer';

import 'package:bitcoin_nft_ui/api/api_constants.dart';
import 'package:http/http.dart';

class UploadInscriptionRequest {
  final String address;
  final String passphrase;
  final int amount;
  final bool isRef;
  final int numBlocks;
  final List<String> urls;
  final bool isSendNft;
  const UploadInscriptionRequest({required this.address, required this.passphrase, required this.amount, required this.isRef, required this.urls, required this.numBlocks, required this.isSendNft});
  //From json and to json converter
  factory UploadInscriptionRequest.fromJson(Map<String, dynamic> json) {
    return UploadInscriptionRequest(
      address: json['address'],
      passphrase: json['passphrase'],
      amount: json['amount'],
      isRef: json['isRef'],
      urls: json['urls'],
      numBlocks: json['numBlocks'],
      isSendNft: json['isSendNft']
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'passphrase': passphrase,
      'amount': amount,
      'isRef': isRef,
      'urls': urls,
      'numBlocks':numBlocks,
      'isSendNft': isSendNft
    };
  }

}

class UploadInscriptionResponse {
  final String revealTxId;
  final String commitTxId;
  final int fee;
  const UploadInscriptionResponse({required this.revealTxId, required this.commitTxId, required this.fee});

  //Convert from and to json
  factory UploadInscriptionResponse.fromJson(String json) {
    final Map<String, dynamic> map = jsonDecode(json);
    return UploadInscriptionResponse(
      revealTxId: map["data"]['revealTxId'],
      commitTxId: map["data"]['commitTxId'],
      fee: map["data"]['fee']
    );
  }

  String toJson() {
    return jsonEncode({
      'revealTxId': revealTxId,
      'commitTxId': commitTxId,
      'fee': fee
    });
  }
}

Future<UploadInscriptionResponse> uploadInscription(UploadInscriptionRequest req) async{
  const url = '$apiEndpoint/send';
  final headers = {'Content-Type': 'application/json'};
  final response = await post(Uri.parse(url), headers: headers, body: jsonEncode(req));
  log("uploadInscription API returns ${response.statusCode} and ${response.body}");
  if (response.statusCode == 200) {
    return UploadInscriptionResponse.fromJson(response.body);
  } else {
    throw Exception('Failed to upload inscription');
  }
}

Future<int> estimateFee(UploadInscriptionRequest req) async {
  const url = '$apiEndpoint/predefine';
  final headers = {'Content-Type': 'application/json'};
  final response = await post(Uri.parse(url), headers: headers, body: jsonEncode(req));
  log("estimatFee API returns ${response.statusCode} and ${response.body}");
  if (response.statusCode == 200) {
    return int.parse(response.body);
  } else {
    throw Exception('Failed to estimate fee');
  }

}