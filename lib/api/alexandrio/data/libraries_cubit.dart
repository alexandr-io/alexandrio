import 'dart:convert';

import 'package:amberkit/amberkit.dart';
import 'package:http/http.dart' as http;

import '../alexandrio.dart';
import 'library.dart';

class LibrariesCubit extends Cubit<List<LibraryCubit>?> {
  final ClientBloc client;
  final String token;

  LibrariesCubit(this.client, this.token) : super(null) {
    refresh();
  }

  void add(Library library) {
    emit([
      ...?state,
      LibraryCubit(client, library),
    ]);
  }

  void delete(LibraryCubit library) {
    emit([
      for (var entry in state ?? [])
        if (entry != library) entry,
    ]);
  }

  Future<void> refresh() async {
    var response = await http.get(
      Uri.parse('https://library.preprod.alexandrio.cloud/libraries'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
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
