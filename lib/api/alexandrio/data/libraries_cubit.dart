import 'dart:convert';

import 'package:amberkit/amberkit.dart';
import 'package:http/http.dart' as http;

import '../alexandrio.dart';
import 'library.dart';

class LibrariesCubit extends Cubit<List<LibraryCubit>?> {
  final ClientBloc client;

  LibrariesCubit(this.client) : super(null) {
    refresh();
  }

  Future<void> refresh() async {
    var state = client.state as ClientConnected;

    var response = await http.get(
      Uri.parse('https://library.alexandrio.cloud/libraries'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${state.token}',
      },
    );
    print(response.body);
    var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
    print(jsonResponse);

    emit([
      for (var library in jsonResponse)
        LibraryCubit(
          client,
          Library(id: library['id'], title: library['name']),
        ),
    ]);
  }
}
