import 'package:bitcoin_nft_ui/features/off_chain/data/mint_off_chain_api.dart';
import 'package:bitcoin_nft_ui/features/on_chain/data/upload_inscription.dart';

class MintNftDomain {
  static Future<(OCDataRequest, SendResponse)> mintNftOffChainDomain(String id, String memo, String filePath) async {
    final res = await mintOffChainNft(id, memo, filePath);
    return res;
  }
}