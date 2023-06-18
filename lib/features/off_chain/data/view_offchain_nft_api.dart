import 'dart:convert';
import 'dart:developer';

import 'package:bitcoin_nft_ui/api/api_constants.dart';
import 'package:http/http.dart';

class OffChainNftStructure {
  final String id;
  final String url;
  final String memo;
  final String txId;
  final String binary;
  const OffChainNftStructure({required this.id, required this.url, required this.memo, required this.txId, required this.binary});
  factory OffChainNftStructure.fromJson(Map<String, dynamic> json){
    return OffChainNftStructure(id: json["id"], url: json["url"], memo: json["memo"], txId: json["txId"], binary: json["binary"]);
  }
}

class OffChainNftResponse{
  final List<OffChainNftStructure> data;
  const OffChainNftResponse({required this.data});  
  factory OffChainNftResponse.fromJson(String json){
    final mp = jsonDecode(json);
    final nftList = mp["data"] as List<dynamic>;
    return OffChainNftResponse(data: nftList.map((e) => OffChainNftStructure.fromJson(e)).toList());
  }
}

Future<OffChainNftResponse> getOffChainNfts() async {
  const url = '$apiEndpoint/view-data';
  final headers = {'Content-Type': 'application/json'};
  final response = await get(Uri.parse(url), headers: headers);
  log(response.body);
  if (response.statusCode == 200) {
    return OffChainNftResponse.fromJson(response.body);
  } else {
    throw Exception('Failed to upload inscription');
  }
}