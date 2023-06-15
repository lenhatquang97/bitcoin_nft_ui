import 'dart:convert';
import 'dart:developer';

import 'package:bitcoin_nft_ui/api/api_constants.dart';
import 'package:http/http.dart';

class InscriptionRequest {
  final String address;
  final String passphrase;
  final bool isRef;
  final List<String> urls;
  final bool isSendNft;
  const InscriptionRequest({required this.address, required this.passphrase, required this.isRef, required this.urls, required this.isSendNft});
  //From json and to json converter
  factory InscriptionRequest.fromJson(Map<String, dynamic> json) {
    return InscriptionRequest(
      address: json['address'],
      passphrase: json['passphrase'],
      isRef: json['isRef'],
      urls: json['urls'],
      isSendNft: json['isSendNft']
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'passphrase': passphrase,
      'isRef': isRef,
      'urls': urls,
      'isSendNft': isSendNft
    };
  }

}

class InscriptionResponse {
  final String revealTxId;
  final String commitTxId;
  final int fee;
  const InscriptionResponse({required this.revealTxId, required this.commitTxId, required this.fee});

  //Convert from and to json
  factory InscriptionResponse.fromJson(String json) {
    final Map<String, dynamic> map = jsonDecode(json);
    return InscriptionResponse(
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

Future<InscriptionResponse> uploadInscription(InscriptionRequest req) async{
  const url = '$apiEndpoint/send';
  final headers = {'Content-Type': 'application/json'};
  final response = await post(Uri.parse(url), headers: headers, body: jsonEncode(req));
  log("uploadInscription API returns ${response.statusCode} and ${response.body}");
  if (response.statusCode == 200) {
    return InscriptionResponse.fromJson(response.body);
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