import 'package:bitcoin_nft_ui/features/off_chain/data/check_balance_api.dart';

class CheckBalanceDomain {
  static Future<CheckBalanceResponse> checkBalanceDomain() async{
    return getBalance();
  }
}