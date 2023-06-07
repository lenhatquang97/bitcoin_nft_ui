import 'dart:convert';
import 'package:bitcoin_nft_ui/api/api_constants.dart';
import 'package:http/http.dart';
//Write POST API about createWallet with name and passphrase and return seed string
Future<String> createWallet(String name, String passphrase) async {
  const url = '$apiEndpoint/wallet';
  final headers = {'Content-Type': 'application/json'};
  final body = '{"name": "$name", "passphrase": "$passphrase"}';
  final encoding = Encoding.getByName('utf-8');
  final response = await post(Uri.parse(url), headers: headers, body: body, encoding: encoding);
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to create wallet');
  }
}