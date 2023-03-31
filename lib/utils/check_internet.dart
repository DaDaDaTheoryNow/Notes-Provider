import 'package:connectivity_plus/connectivity_plus.dart';

class Internet {
  Future<bool> checkInternet() async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    // ПЕРЕДЕЛАТЬ В CASE
    if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      return true;
    } else {
      return false;
    }
  }
}
