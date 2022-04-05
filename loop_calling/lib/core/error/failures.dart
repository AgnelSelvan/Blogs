import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);
}

class ServerFailure extends Failure {
  final _message = "Error in Getting Data";

  @override
  String toString() {
    return _message;
  }

  @override
  List<Object?> get props => [];
}

class UnknownFailure extends Failure {
  late final message;

  UnknownFailure(String msg) {
    message = msg;
  }

  @override
  String toString() {
    return message;
  }

  @override
  List<Object?> get props => [];
}

class NullDataFailure extends Failure {
  final message = "No Data to display";

  @override
  String toString() {
    return message;
  }

  @override
  List<Object?> get props => [];
}
