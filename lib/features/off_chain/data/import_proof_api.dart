import 'dart:convert';
import 'dart:developer';

import 'package:bitcoin_nft_ui/api/api_constants.dart';
import 'package:http/http.dart';

class ImportProofRequest{
  final String id;
  final String url;
  final String memo;
  const ImportProofRequest({required this.id, required this.url, required this.memo});

  Map<String, dynamic> toJson(){
    return {
      "id": id,
      "url": url,
      "memo": memo
    };
  }
}

Future<int> importProof(ImportProofRequest req, String filePath) async{
  final ipfsUrl = '$apiEndpoint/ipfs-link?filePath=$filePath';
  final ipfsHeaders = {'Content-Type': 'application/json'};
  final ipfsResponse = await get(Uri.parse(ipfsUrl), headers: ipfsHeaders);
  if(ipfsResponse.statusCode == 200) {
    log(ipfsResponse.body);
    const url = '$apiEndpoint/import';
    final headers = {'Content-Type': 'application/json'};
    final response = await post(Uri.parse(url), headers: headers, body: jsonEncode(ImportProofRequest(id: req.id, url: ipfsResponse.body, memo: req.memo)));
    return response.statusCode;
  } 
  return ipfsResponse.statusCode;
}