import 'package:alexandrio/api/alexandrio/data/libraries_cubit.dart';
import 'package:equatable/equatable.dart';

abstract class ClientState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ClientDisconnected extends ClientState {}

class ClientConnecting extends ClientState {
  final String login;
  final String password;

  ClientConnecting({
    required this.login,
    required this.password,
  });

  @override
  List<Object?> get props => [login, password, ...super.props];
}

class ClientConnected extends ClientState {
  final String login;
  final String token;
  final String password;

  ClientConnected({
    required this.login,
    required this.token,
    required this.password,
  });

  @override
  List<Object?> get props => [login, token, password, ...super.props];
}

class ClientErrored extends ClientState {
  final String error;

  ClientErrored({
    required this.error,
  });

  @override
  List<Object?> get props => [error, ...super.props];
}
