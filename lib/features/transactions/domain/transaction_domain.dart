import 'package:bitcoin_nft_ui/features/transactions/data/transaction_api.dart';

class TransactionDomain{
  static Future<GetTransactionResponse> getTransactionDomain(String txId) async {
    try{
      final res = getTx(txId);
      return res;
    } catch (e){
      return GetTransactionResponse.init();
    }
  }
}