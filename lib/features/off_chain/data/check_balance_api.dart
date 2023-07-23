import 'dart:convert';

import 'package:bitcoin_nft_ui/api/api_constants.dart';
import 'package:http/http.dart';

class CheckBalanceResponse{
  final int balance;
  final String account;
  const CheckBalanceResponse({required this.balance, required this.account});
  //Convert from and to json
  factory CheckBalanceResponse.fromJson(String json) {
    final Map<String, dynamic> map = jsonDecode(json);
    return CheckBalanceResponse(
      balance: map["data"]["balance"],
      account: map["data"]["account"]
    );
  }

  String toJson() {
    return jsonEncode({
      'data': balance,
      'account': account
    });
  }
}

Future<CheckBalanceResponse> getBalance() async{
  const url = '$apiEndpoint/balance';
  final headers = {'Content-Type': 'application/json'};
  final response = await get(Uri.parse(url), headers: headers);
  if(response.statusCode == 200) {
    return CheckBalanceResponse.fromJson(response.body);
  } else {
    throw Exception('Failed to get balance');
  }
}