import 'package:connectivity_plus/connectivity_plus.dart';

class Internet {
  Future<bool> checkInternet() async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    switch (connectivityResult) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.ethernet:
        return true;
      default:
        return false;
    }
  }
}
