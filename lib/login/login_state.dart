import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginDisconnected extends LoginState {}

class LoginConnecting extends LoginState {
  final String login;
  final String password;

  LoginConnecting({
    required this.login,
    required this.password,
  });

  @override
  List<Object?> get props => [login, password, ...super.props];
}

class LoginConnected extends LoginState {
  final String login;
  final String token;
  final String password;

  LoginConnected({
    required this.login,
    required this.token,
    required this.password,
  });

  @override
  List<Object?> get props => [login, token, password, ...super.props];
}

class LoginErrored extends LoginState {
  final String error;

  LoginErrored({
    required this.error,
  });

  @override
  List<Object?> get props => [error, ...super.props];
}
