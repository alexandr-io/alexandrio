import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amberkit/amberkit.dart';
import 'package:http/http.dart' as http;

import 'client_event.dart';
import 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  Timer? timer;

  ClientBloc() : super(ClientDisconnected()) {
    // TODO: Reconnect here if credentials exists
  }

  @override
  void onChange(Change<ClientState> change) {
    if (change.nextState is ClientConnected) {
      var realState = change.nextState as ClientConnected;
      realState.token;
      timer = Timer.periodic(Duration(minutes: 5), (timer) {
        add(ClientConnect(realState.login, realState.password));
      });
    } else {}
    super.onChange(change);
  }

  @override
  Stream<ClientState> mapEventToState(ClientEvent event) async* {
    if (event is ClientConnect) {
      yield ClientConnecting(login: event.login, password: event.password);

      // await Future.delayed(Duration(seconds: 2));
      var response = await http.post(
        Uri.parse('https://auth.alexandrio.cloud/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'login': event.login,
          'password': event.password,
        }),
      );
      var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      print(jsonResponse);

      yield ClientConnected(login: event.login, token: jsonResponse['auth_token'], password: event.password, client: this);
    } else if (event is ClientDisconnect) {
      await Future.delayed(Duration(seconds: 2));
      yield ClientDisconnected();
    }
  }
}
