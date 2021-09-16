import 'dart:convert';

import 'package:amberkit/amberkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_epub_reader/flutter_epub_reader.dart';
import 'package:flutter_pdf_parser/flutter_pdf_parser.dart';
import 'package:http/http.dart' as http;

import '/widgets/modal/book_create_update_modal.dart';
import '/widgets/modal/book_delete_modal.dart';

import '/api/alexandrio/alexandrio.dart' as alexandrio;

class BookModal extends StatelessWidget {
  final alexandrio.ClientBloc client;
  final alexandrio.BookCubit book;
  final alexandrio.LibraryCubit library;

  const BookModal({
    Key? key,
    required this.client,
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
            onTap: () async {
              var realState = client.state as alexandrio.ClientConnected;
              var response = await http.get(
                Uri.parse('https://media.alexandrio.cloud/book/${book.state.id}/download'),
                headers: {
                  // 'Content-Type': 'application/json',
                  'Authorization': 'Bearer ${realState.token}',
                },
              );
              if (response.statusCode != 200) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Couldn\'t download book'),
                  behavior: SnackBarBehavior.floating,
                ));
              }
              var contentType = response.headers['content-type'];
              switch (contentType) {
                case 'application/pdf':
                  print('pdf detected');
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => PDFBook(
                        token: realState.token,
                        id: book.state.id,
                        bytes: response.bodyBytes,
                        title: book.state.title,
                      ),
                    ),
                  );
                  break;
                case 'application/zip':
                  print('epub detected');
                  var getProgression = await http.get(
                    Uri.parse('https://library.alexandrio.cloud/library/${library.state.id}/book/${book.state.id}/progress'),
                    headers: {
                      'Content-Type': 'application/json',
                      'Authorization': 'Bearer ${realState.token}',
                    }
                  );
                  if (getProgression.statusCode != 200) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Couldn\'t get progress'),
                      behavior: SnackBarBehavior.floating,
                    ));
                  }
                  var json = jsonDecode(utf8.decode(getProgression.bodyBytes)) ?? '';
                  var progress = json['progress'];
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => EPUBBook(
                        token: realState.token,
                        book: book.state.id,
                        library: library.state.id,
                        bytes: response.bodyBytes,
                        title: book.state.title,
                        progress: progress,
                      ),
                    ),
                  );
                  break;
                default:
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Unknown file format: $contentType'),
                    behavior: SnackBarBehavior.floating,
                  ));
                  break;
              }
              // print(response.headers['content-type']); // return BookData(
              // bytes: response.bodyBytes,
              // mime: response.headers['content-type'],
              // );
              // Navigator.of(context).pop();
              // BottomModal.show(context: context, child: BookCreateUpdateModal());
            },
          ),
          // Tile(
          //   leading: Icon(Icons.edit),
          //   title: 'Edit',
          //   onTap: () {
          //     Navigator.of(context).pop();
          //     BottomModal.show(context: context, child: BookCreateUpdateModal(client: client, book: book, library: library));
          //   },
          // ),
          Tile(
            leading: Icon(Icons.delete),
            title: 'Delete',
            onTap: () {
              Navigator.of(context).pop();
              BottomModal.show(context: context, child: BookDeleteModal(client: client, book: book, library: library));
            },
          ),
        ],
      );
}
