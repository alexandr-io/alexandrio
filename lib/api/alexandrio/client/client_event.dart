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

class ClientRegister extends ClientEvent {
  final String login;
  final String password;
  final String email;
  final String invite;

  ClientRegister(this.login, this.password, this.email, this.invite);

  @override
  List<Object?> get props => [login, password, email, invite, ...super.props];
}

class ClientDisconnect extends ClientEvent {}

class ClientError extends ClientEvent {
  final String error;

  ClientError(this.error);

  @override
  List<Object?> get props => [error, ...super.props];
}
