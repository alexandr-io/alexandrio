import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amberkit/amberkit.dart';
import 'package:http/http.dart' as http;

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

      yield ClientConnected(login: event.login, token: jsonResponse['auth_token'], password: event.password);
    } else if (event is ClientDisconnect) {
      await Future.delayed(Duration(seconds: 2));
      yield ClientDisconnected();
    }
  }
}
