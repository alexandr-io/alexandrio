import 'dart:convert';

import 'package:amberkit/amberkit.dart';
import 'package:http/http.dart' as http;

import '../alexandrio.dart';
import 'book.dart';

class BooksCubit extends Cubit<List<Book>?> {
  final ClientBloc client;
  final Library library;

  BooksCubit(this.client, this.library) : super(null) {
    refresh();
  }

  Future<void> refresh() async {
    var state = client.state as ClientConnected;

    var response = await http.get(
      Uri.parse('https://library.alexandrio.cloud/library/${library.id}/books'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${state.token}',
      },
    );

    print(response.body);
    var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
    print(jsonResponse);

    emit([
      for (var book in jsonResponse)
        Book(
          title: book['Title'],
          author: book['Author']?.isEmpty ? null : book['Author'],
          description: book['Description']?.isEmpty ? null : book['Description'],
        ),
    ]);
  }
}
