import 'package:bitcoin_nft_ui/features/on_chain/data/nft_getter.dart';

class NftGetterDomain{
  static Future<List<NftStructure>> nftGetterDomain() async {
    try {
      final res = await getMultipleNfts();
      return res.data;
    } catch (e) {
      return List.empty();
    }
  }
}