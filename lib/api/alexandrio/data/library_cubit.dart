import 'package:amberkit/amberkit.dart';

import '../alexandrio.dart';
import 'books_cubit.dart';
import 'library.dart';

class LibraryCubit extends Cubit<Library> {
  late BooksCubit books;

  LibraryCubit(ClientBloc client, Library library) : super(library) {
    books = BooksCubit(client, library);
  }
}
