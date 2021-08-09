import 'package:equatable/equatable.dart';

abstract class ClientEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ClientConnect extends ClientEvent {
  final String login;
  final String password;

  ClientConnect(this.login, this.password);

  @override
  List<Object?> get props => [login, password, ...super.props];
}

class ClientDisconnect extends ClientEvent {}

class ClientError extends ClientEvent {
  final String error;

  ClientError(this.error);

  @override
  List<Object?> get props => [error, ...super.props];
}
