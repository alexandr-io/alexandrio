import 'package:amberkit/amberkit.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http;

import '/api/alexandrio/alexandrio.dart' as alexandrio;

class BookCoverUploadModal extends StatelessWidget {
  final alexandrio.BookCubit book;
  final alexandrio.LibraryCubit library;
  final alexandrio.ClientBloc client;

  const BookCoverUploadModal({
    Key? key,
    required this.book,
    required this.library,
    required this.client,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        // shrinkWrap: true,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: kPadding.vertical),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kPadding.horizontal),
            child: Text('Upload cover for ${book.state.title} in ${library.state.title}?', style: Theme.of(context).textTheme.headline6),
          ),
          SizedBox(height: kPadding.vertical),
          SizedBox(
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: kPadding.vertical * 1.25),
                      child: Center(child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold))),
                    ),
                  ),
                ),
                Container(height: kPadding.vertical * 2.0, width: 1.0, color: Theme.of(context).dividerColor),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      var messenger = ScaffoldMessenger.of(context);
                      Navigator.of(context).pop();
                      var clientState = client.state as alexandrio.ClientConnected;

                      var file = await FilePickerCross.importFromStorage(
                        type: FileTypeCross.image,
                        // fileExtension: 'png',
                      );

                      // if (file == null) return;

                      var request = http.MultipartRequest(
                        'POST',
                        Uri.parse('https://media.preprod.alexandrio.cloud/book/cover/upload'),
                      );
                      request.files.add(
                        http.MultipartFile.fromBytes(
                          'cover',
                          file.toUint8List(),
                          filename: file.fileName,
                          // contentType: http.MediaType.parse('image/png'),
                        ),
                      );
                      request.fields['book_id'] = book.state.id;
                      request.fields['library_id'] = library.state.id;
                      request.headers['Authorization'] = 'Bearer ${clientState.token}';
                      var res = await request.send();
                      print(res);

                      if (res.statusCode != 204) {
                        messenger.showSnackBar(SnackBar(
                          content: Text('Couldn\'t upload book cover'),
                        ));
                      }
                      await library.books.refresh();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: kPadding.vertical * 1.25),
                      child: Center(child: Text('Upload Cover', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
