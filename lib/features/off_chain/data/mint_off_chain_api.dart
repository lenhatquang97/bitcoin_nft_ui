import 'dart:convert';

import 'package:bitcoin_nft_ui/api/api_constants.dart';
import 'package:bitcoin_nft_ui/features/off_chain/data/import_proof_api.dart';
import 'package:bitcoin_nft_ui/features/on_chain/data/upload_inscription.dart';
import 'package:http/http.dart';

class OCDataRequest {
  final String id;
  final String url;
  final String memo;
  const OCDataRequest(
      {required this.id, required this.url, required this.memo});
  Map<String, dynamic> toJson() {
    return {'id': id, 'url': url, 'memo': memo};
  }
}

class MintRequest {
  final String address;
  final String passphrase;
  final bool isSendNft;
  final OCDataRequest data;
  const MintRequest(
      {required this.address,
      required this.passphrase,
      required this.isSendNft,
      required this.data});
  //From json and to json converter
  factory MintRequest.fromJson(Map<String, dynamic> json) {
    return MintRequest(
        address: json['address'],
        passphrase: json['passphrase'],
        isSendNft: json['isSendNft'],
        data: json['data']);
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'passphrase': passphrase,
      'isSendNft': isSendNft,
      'data': data
    };
  }
}

Future<(OCDataRequest, SendResponse)> mintOffChainNft(
    String id, String memo, String filePath) async {
  final ipfsUrl = '$apiEndpoint/ipfs-link?filePath=$filePath';
  final ipfsHeaders = {'Content-Type': 'application/json'};
  final ipfsResponse = await get(Uri.parse(ipfsUrl), headers: ipfsHeaders);
  if (ipfsResponse.statusCode == 200) {
    final ipfsUrl = IpfsUrlResponse.fromJson(ipfsResponse.body);
    const url = '$apiEndpoint/send';
    final headers = {'Content-Type': 'application/json'};

    final ocReq = OCDataRequest(id: id, url: ipfsUrl.url, memo: memo);
    final req = MintRequest(
        address: "default", passphrase: "12345", isSendNft: true, data: ocReq);

    final response =
        await post(Uri.parse(url), headers: headers, body: jsonEncode(req));

    return response.statusCode == 200
        ? (ocReq, SendResponse.fromJson(response.body))
        : (
            const OCDataRequest(id: "", url: "", memo: ""),
            const SendResponse(revealTxId: "", commitTxId: "", fee: -1)
          );
  }
  return (
    const OCDataRequest(id: "", url: "", memo: ""),
    const SendResponse(revealTxId: "", commitTxId: "", fee: -1)
  );
}
