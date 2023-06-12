import 'dart:convert';

import 'package:bitcoin_nft_ui/api/api_constants.dart';
import 'package:http/http.dart';

class ExportProofRequest{
  final String url;
  const ExportProofRequest({required this.url});

  Map<String, dynamic> toJson(){
    return {
      "url": url
    };
  }
}

class ExportProofResponse {
  final String id;
  final String url;
  final String memo;
  const ExportProofResponse({required this.id, required this.url, required this.memo});

  //Convert from and to json
  factory ExportProofResponse.fromJson(String json) {
    final Map<String, dynamic> map = jsonDecode(json);
    return ExportProofResponse(
      id: map["data"]['id'],
      url: map["data"]['url'],
      memo: map["data"]['memo']
    );
  }

  String toJson() {
    return jsonEncode({
      'id': id,
      'url': url,
      'memo': memo
    });
  }
}
Future<ExportProofResponse> exportProof(ExportProofRequest req) async{
  const url = '$apiEndpoint/export';
  final headers = {'Content-Type': 'application/json'};
  final response = await post(Uri.parse(url), headers: headers, body: jsonEncode(req));
  if(response.statusCode == 200) {
    return ExportProofResponse.fromJson(response.body);
  } else {
    throw Exception('Export proof');
  }
}