import 'package:bitcoin_nft_ui/api/api_constants.dart';
import 'package:http/http.dart';
import 'dart:convert';

//Write GET API about getTx with query params as txId and return tx object
Future<Map<String, dynamic>> getTx(String txId) async {
  final url = '$apiEndpoint/tx?txid=$txId';
  final headers = {'Content-Type': 'application/json'};
  final response = await get(Uri.parse(url), headers: headers);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to get tx');
  }
}