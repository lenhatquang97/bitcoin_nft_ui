import 'dart:convert';

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

Future<int> importProof(ImportProofRequest req) async{
  const url = '$apiEndpoint/import';
  final headers = {'Content-Type': 'application/json'};
  final response = await post(Uri.parse(url), headers: headers, body: jsonEncode(req));
  return response.statusCode;
}