import 'dart:convert';

import 'package:alexandrio/api/alexandrio/data/book_cubit.dart';
import 'package:amberkit/amberkit.dart';
import 'package:http/http.dart' as http;

import '../alexandrio.dart';
import 'book.dart';

class BooksCubit extends Cubit<List<BookCubit>?> {
  final ClientBloc client;
  final Library library;

  BooksCubit(this.client, this.library) : super(null) {
    refresh();
  }

  void add(Book book) {
    emit([
      ...?state,
      BookCubit(book),
    ]);
  }

  void delete(BookCubit book) {
    emit([
      for (var entry in state ?? [])
        if (entry != book) entry,
    ]);
  }

  Future<void> refresh() async {
    try {
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

      if (jsonResponse == null) {
        emit([]);
      } else {
        emit([
          for (var book in jsonResponse)
            BookCubit(
              Book(
                id: book['id'],
                title: book['Title'] ?? book['title'] ?? 'unnamed',
                author: book['Author'] ?? book['author'],
                description: book['Description'] ?? book['description'],
                thumbnail: (book['thumbnails'] != null && book['thumbnails'].isNotEmpty) ? book['thumbnails'].last.replaceAll('http://', 'https://') : null,
                // title: book['title'],
                // author: book['author'],
                // description: book['description'],
              ),
            ),
        ]);
      }
    } catch (e) {
      emit([]);
    }
  }
}
