import 'package:bitcoin_nft_ui/features/off_chain/data/export_proof_api.dart';
import 'package:bitcoin_nft_ui/features/off_chain/data/import_proof_api.dart';
import 'package:bitcoin_nft_ui/features/off_chain/data/view_offchain_nft_api.dart';

class ImportProofDomain {
  static Future<int> importProofDomain(String id, String url, String memo) async{
    ImportProofRequest req = ImportProofRequest(id: id, url: url, memo: memo);
    return importProof(req);
  }

  static Future<ExportProofResponse> exportProofDomain(String url) async {
    final req = ExportProofRequest(url: url);
    try {
      final res = await exportProof(req);
      return res;
    } catch (e) {
      return const ExportProofResponse(id: "", url: "", memo: "");
    }
  }

  static Future<OffChainNftResponse> viewOffChainNfts() async{
    try {
      final res = await getOffChainNfts();
      return res;
    } catch (e) {
      return const OffChainNftResponse(data: []);
    }
  }
}