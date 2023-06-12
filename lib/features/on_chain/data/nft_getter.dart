import 'dart:convert';
import 'dart:developer';

import 'package:bitcoin_nft_ui/api/api_constants.dart';
import 'package:http/http.dart';

class NftStructure {
  final String hexData;
  final String mimeType;
  final String txId;
  const NftStructure({required this.hexData, required this.mimeType, required this.txId});
  factory NftStructure.fromJson(Map<String, dynamic> json){
    return NftStructure(hexData: json["hexData"], mimeType: json["mimeType"], txId: json["txId"]);
  }
}

class NftResponse{
  final List<NftStructure> data;
  const NftResponse({required this.data});  
  factory NftResponse.fromJson(String json){
    final mp = jsonDecode(json);
    final nftList = mp["data"] as List<dynamic>;
    return NftResponse(data: nftList.map((e) => NftStructure.fromJson(e)).toList());
  }
}

Future<NftResponse> getMultipleNftsBasedOnAddress(String address) async {
  final url = '$apiEndpoint/on-chain-nft?address=$address';
  final headers = {'Content-Type': 'application/json'};
  final response = await get(Uri.parse(url), headers: headers);
  log("getMultipleNftsBasedOnAddress API returns ${response.statusCode} and ${response.body}");
  if (response.statusCode == 200) {
    return NftResponse.fromJson(response.body);
  } else {
    throw Exception('Failed to upload inscription');
  }
}
