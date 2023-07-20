import 'dart:convert';
import 'dart:developer';

import 'package:bitcoin_nft_ui/api/api_constants.dart';
import 'package:http/http.dart';

class InscriptionRequest {
  final String address;
  final String passphrase;
  final bool isRef;
  final List<String> onChainData;
  final bool isSendNft;
  final bool isMint;
  final String txId;
  final List<String> offChainData;
  const InscriptionRequest({required this.address, required this.passphrase, required this.isRef, required this.onChainData, required this.isSendNft, required this.isMint, required this.txId, required this.offChainData});
  //From json and to json converter
  factory InscriptionRequest.fromJson(Map<String, dynamic> json) {
    return InscriptionRequest(
      address: json['address'],
      passphrase: json['passphrase'],
      isRef: json['isRef'],
      onChainData: json['onChainData'],
      isSendNft: json['isSendNft'],
      isMint: json['isMint'],
      txId: json["txId"],
      offChainData: json["offChainData"]
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'passphrase': passphrase,
      'isRef': isRef,
      'onChainData': onChainData,
      'isSendNft': isSendNft,
      'isMint': isMint,
      'txId': txId,
      'offChainData': offChainData
    };
  }
}

class SendResponse {
  final String revealTxId;
  final String commitTxId;
  final int fee;
  const SendResponse({required this.revealTxId, required this.commitTxId, required this.fee});

  //Convert from and to json
  factory SendResponse.fromJson(String json) {
    final Map<String, dynamic> map = jsonDecode(json);
    return SendResponse(
      revealTxId: map["data"]['revealTxId'],
      commitTxId: map["data"]['commitTxId'],
      fee: map["data"]['fee']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'revealTxId': revealTxId,
      'commitTxId': commitTxId,
      'fee': fee
    };
  }
}

Future<SendResponse> uploadInscription(InscriptionRequest req) async{
  const url = '$apiEndpoint/send';
  final headers = {'Content-Type': 'application/json'};
  final response = await post(Uri.parse(url), headers: headers, body: jsonEncode(req));
  log("uploadInscription API returns ${response.statusCode} and ${response.body}");
  if (response.statusCode == 200) {
    return SendResponse.fromJson(response.body);
  } else {
    throw Exception('Failed to upload inscription');
  }
}

Future<int> estimateFee(InscriptionRequest req) async {
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