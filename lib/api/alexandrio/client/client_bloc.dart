import 'package:flutter_bloc/flutter_bloc.dart';

import 'client_event.dart';
import 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  ClientBloc() : super(ClientDisconnected()) {
    // TODO: Reconnect here if credentials exists
  }

  @override
  Stream<ClientState> mapEventToState(ClientEvent event) async* {
    if (event is ClientConnect) {
      yield ClientConnecting(login: event.login, password: event.password);
      await Future.delayed(Duration(seconds: 2));
      yield ClientConnected(login: event.login, token: '', password: event.password);
    } else if (event is ClientDisconnect) {
      await Future.delayed(Duration(seconds: 2));
      yield ClientDisconnected();
    }
  }
}
