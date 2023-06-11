import 'dart:developer';

import 'package:http/http.dart';
import 'dart:convert';

class TxInput {
  final int vout;
  final String scriptPubKeyAddress;
  final int value;
  final List<String> witness;
  const TxInput({required this.vout, required this.scriptPubKeyAddress, required this.value, required this.witness});
  factory TxInput.fromJson(dynamic json){
    return TxInput(
      vout: json["vout"], 
      scriptPubKeyAddress: json["prevout"]["scriptpubkey_address"], 
      value: json["prevout"]["value"], 
      witness: (json["witness"] as List<dynamic>).map((e) => e.toString()).toList()
    );
  }
  Map<String, String> outputToMap(){
    return {
      "Vout": vout.toString(),
      "Script PubKeyAddress": scriptPubKeyAddress,
      "Value": value.toString(),
      "Witness": "",
      witness.join("\n"): ""
    };
  }

}

class TxOutput {
  final String scriptPubKeyAddress;
  final int value;
  const TxOutput({required this.scriptPubKeyAddress, required this.value});
  factory TxOutput.fromJson(dynamic json){
    return TxOutput(scriptPubKeyAddress: json["scriptpubkey_address"], value: json["value"]);
  }
  Map<String, String> outputToMap(){
    return {
      "Output Address": scriptPubKeyAddress,
      "Value": value.toString()
    };
  }
}

class GetTransactionResponse {
  final String txid;
  final List<TxInput> vin;
  final List<TxOutput> vout;
  final int size;
  final int weight;
  final int fee;
  final int blockHeight;
  const GetTransactionResponse({required this.txid, required this.vin, required this.vout, required this.size, required this.fee, required this.weight, required this.blockHeight});
  factory GetTransactionResponse.fromJson(String json) {
    final Map<String, dynamic> mp = jsonDecode(json);
    return GetTransactionResponse(
      txid: mp["txid"],
      size: mp["size"],
      weight: mp["weight"],
      fee: mp["fee"],
      blockHeight: mp["status"]["block_height"],
      vin: (mp["vin"] as List<dynamic>).map(TxInput.fromJson).toList(),
      vout: (mp["vout"] as List<dynamic>).map(TxOutput.fromJson).toList()
    );
  }
  String toJson() {
    return jsonEncode({
      'txid': txid,
      'size': size,
      'weight': weight,
      'fee': fee,
      'block_height': blockHeight
    });
  }

  Map<String, String> outputToMap(){
    return {
      "Transaction Id": txid,
      "Size": size.toString(),
      "Weight": weight.toString(),
      "Fee": fee.toString(),
      "Block Height": blockHeight.toString()
    };
  }

  factory GetTransactionResponse.init(){
    return const GetTransactionResponse(txid: "", vin: [], vout: [], size: -1, fee: -1, weight: -1, blockHeight: -1);
  }

}

//Write GET API about getTx with query params as txId and return tx object
Future<GetTransactionResponse> getTx(String txId) async {
  final url = 'https://blockstream.info/testnet/api/tx/$txId';
  final headers = {'Content-Type': 'application/json'};
  final response = await get(Uri.parse(url), headers: headers);
  if (response.statusCode == 200) {
    return GetTransactionResponse.fromJson(response.body);
  } else {
    throw Exception('Failed to get tx');
  }
}