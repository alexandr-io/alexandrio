import 'package:amberkit/amberkit.dart';
import 'package:flutter/material.dart';

import '/widgets/modal/library_delete_modal.dart';
import '/widgets/modal/book_create_update_modal.dart';
import '/widgets/modal/book_delete_modal.dart';
import 'library_create_update_modal.dart';

import '/api/alexandrio/alexandrio.dart' as alexandrio;

class BookModal extends StatelessWidget {
  final alexandrio.BookCubit book;
  final alexandrio.LibraryCubit library;

  const BookModal({
    Key? key,
    required this.book,
    required this.library,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        // shrinkWrap: true,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: kPadding.vertical),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kPadding.horizontal),
            child: Text(book.state.title, style: Theme.of(context).textTheme.headline6),
          ),
          if (book.state.author != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kPadding.horizontal),
              child: Text('by ${book.state.author}', style: Theme.of(context).textTheme.subtitle1),
            ),
          SizedBox(height: kPadding.vertical),
          if (book.state.description != null) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kPadding.horizontal),
              child: Text(book.state.description!, style: Theme.of(context).textTheme.subtitle2, textAlign: TextAlign.left),
            ),
            SizedBox(height: kPadding.vertical),
          ],
          Tile(
            leading: Icon(Icons.book),
            title: 'Read',
            onTap: () {
              // Navigator.of(context).pop();
              // BottomModal.show(context: context, child: BookCreateUpdateModal());
            },
          ),
          Tile(
            leading: Icon(Icons.edit),
            title: 'Edit',
            onTap: () {
              Navigator.of(context).pop();
              BottomModal.show(context: context, child: BookCreateUpdateModal(book: book, library: library));
            },
          ),
          Tile(
            leading: Icon(Icons.delete),
            title: 'Delete',
            onTap: () {
              Navigator.of(context).pop();
              BottomModal.show(context: context, child: BookDeleteModal(book: book, library: library));
            },
          ),
        ],
      );
}
