import 'dart:convert';
import 'dart:developer';

import 'package:bitcoin_nft_ui/api/api_constants.dart';
import 'package:bitcoin_nft_ui/features/on_chain/data/upload_inscription.dart';
import 'package:http/http.dart';


Future<InscriptionResponse> sendInscription(InscriptionRequest req) async{
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