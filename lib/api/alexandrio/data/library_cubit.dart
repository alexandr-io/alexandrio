import 'package:amberkit/amberkit.dart';
import 'package:http/http.dart' as http;

import '../alexandrio.dart';
import 'book.dart';
import 'books_cubit.dart';
import 'library.dart';

class LibraryCubit extends Cubit<Library> {
  late BooksCubit books;

  LibraryCubit(ClientBloc client, Library library) : super(library) {
    books = BooksCubit(client, library);
  }
}
