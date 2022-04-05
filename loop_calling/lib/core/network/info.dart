import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool>? get isConnected;
  Stream<InternetConnectionStatus> get onNetworkStatusChange;
}

class NetworkInfoImpl implements NetworkInfo {
  InternetConnectionChecker dataConnectionChecker;

  NetworkInfoImpl(this.dataConnectionChecker);
  @override
  Future<bool>? get isConnected => dataConnectionChecker.hasConnection;

  @override
  Stream<InternetConnectionStatus> get onNetworkStatusChange =>
      dataConnectionChecker.onStatusChange;
}
