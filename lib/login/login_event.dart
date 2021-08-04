import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginConnect extends LoginEvent {
  final String login;
  final String password;

  LoginConnect({
    required this.login,
    required this.password,
  });

  @override
  List<Object?> get props => [login, password, ...super.props];
}

class LoginDisconnect extends LoginEvent {}
