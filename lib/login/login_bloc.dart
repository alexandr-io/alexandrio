import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginDisconnected()) {
    // TODO: Reconnect here if credentials exists
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginConnect) {
      yield LoginConnecting(login: event.login, password: event.password);
      await Future.delayed(Duration(seconds: 2));
      // yield LoginConnected(login: event.login, token: '', password: event.password);
    } else if (event is LoginDisconnect) {
      await Future.delayed(Duration(seconds: 2));
      yield LoginDisconnected();
    }
  }
}
