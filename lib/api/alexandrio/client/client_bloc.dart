import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amberkit/amberkit.dart';
import 'package:http/http.dart' as http;

import 'client_event.dart';
import 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  Timer? timer;
  final Box accountBox;

  ClientBloc(this.accountBox) : super(ClientDisconnected()) {
    var login = accountBox.get('login');
    var password = accountBox.get('password');
    if (login != null && password != null) {
      add(ClientConnect(login, password));
    }

    timer = Timer.periodic(Duration(minutes: 1), (timer) async {
      if (state is ClientConnected) {
        var realState = state as ClientConnected;

        var response = await http.post(
          Uri.parse('https://auth.alexandrio.cloud/login'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'login': realState.login,
            'password': realState.password,
          }),
        );
        var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        print(jsonResponse);

        emit(ClientConnected(login: realState.login, token: jsonResponse['auth_token'], password: realState.password, client: this));
      }
    });
  }

  @override
  void onChange(Change<ClientState> change) async {
    super.onChange(change);
  }

  @override
  Stream<ClientState> mapEventToState(ClientEvent event) async* {
    if (event is ClientConnect) {
      yield ClientConnecting(login: event.login, password: event.password);

      try {
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

        await accountBox.put('login', event.login);
        await accountBox.put('password', event.password);
      } catch (e) {
        yield ClientErrored(error: 'Couldn\'t login to account, please check your input fields');
        // yield ClientErrored(error: '$e');
      }
    } else if (event is ClientDisconnect) {
      await accountBox.clear();
      yield ClientDisconnected();
    } else if (event is ClientRegister) {
      try {
        var response = await http.post(
          Uri.parse('https://auth.alexandrio.cloud/register'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            // 'login': event.login,
            // 'password': event.password,
            'invitation_token': event.invite,
            'username': event.login,
            'password': event.password,
            'confirm_password': event.password,
            'email': event.email,
          }),
        );
        var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        print(jsonResponse);

        yield ClientConnected(login: event.login, token: jsonResponse['auth_token'], password: event.password, client: this);
      } catch (e) {
        yield ClientErrored(error: 'Couldn\'t register account, please check your input fields');
      }
    }
  }
}
