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

class IpfsUrlResponse {
  final String url;
  const IpfsUrlResponse({required this.url});

  //Convert from and to json
  factory IpfsUrlResponse.fromJson(String json) {
    final Map<String, dynamic> map = jsonDecode(json);
    return IpfsUrlResponse(
      url: map['url'],
    );
  }

}

Future<int> importProof(ImportProofRequest req) async{
  const url = '$apiEndpoint/import';
  final headers = {'Content-Type': 'application/json'};
  final response = await post(Uri.parse(url), headers: headers, body: jsonEncode(ImportProofRequest(id: req.id, url: req.url, memo: req.memo)));
  log("Import successfully");
  return response.statusCode;
}