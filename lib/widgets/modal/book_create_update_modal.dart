import 'dart:convert';
import 'dart:typed_data';

import 'package:amberkit/amberkit.dart';
import 'package:flutter/material.dart';

import '/api/alexandrio/alexandrio.dart' as alexandrio;

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http;

class BookCreateUpdateModal extends StatefulWidget {
  final alexandrio.ClientBloc client;
  final alexandrio.BookCubit? book;
  final alexandrio.LibraryCubit library;
  final Uint8List? bytes;

  const BookCreateUpdateModal({
    Key? key,
    required this.client,
    this.book,
    required this.library,
    this.bytes,
  }) : super(key: key);

  @override
  State<BookCreateUpdateModal> createState() => _BookCreateUpdateModalState();
}

class _BookCreateUpdateModalState extends State<BookCreateUpdateModal> {
  late TextEditingController titleController;
  late TextEditingController authorController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    titleController = TextEditingController(text: widget.book?.state.title);
    authorController = TextEditingController(text: widget.book?.state.author);
    descriptionController = TextEditingController(text: widget.book?.state.description);
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    authorController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        // shrinkWrap: true,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: kPadding.vertical),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kPadding.horizontal),
            child: Text(widget.book == null ? 'Upload \$fileName to ${widget.library.state.title}' : 'Edit ${widget.book!.state.title} in ${widget.library.state.title}', style: Theme.of(context).textTheme.headline6),
          ),
          SizedBox(height: kPadding.vertical),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kPadding.horizontal),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                filled: true,
              ),
            ),
          ),
          SizedBox(height: kPadding.vertical),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kPadding.horizontal),
            child: TextField(
              controller: authorController,
              decoration: InputDecoration(
                labelText: 'Author',
                filled: true,
              ),
            ),
          ),
          SizedBox(height: kPadding.vertical),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kPadding.horizontal),
            child: TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                filled: true,
              ),
            ),
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
                      Navigator.of(context).pop();
                      if (widget.book != null) {
                        widget.book!.emit(alexandrio.Book(
                          id: widget.book!.state.id,
                          title: titleController.text,
                          author: authorController.text,
                          description: descriptionController.text,
                        ));
                      } else if (widget.bytes != null) {
                        // bytes
                        var clientState = widget.client.state as alexandrio.ClientConnected;
                        var response = await http.post(
                          Uri.parse('https://library.alexandrio.cloud/library/${widget.library.state.id}/book'),
                          headers: {
                            'Content-Type': 'application/json',
                            'Authorization': 'Bearer ${clientState.token}',
                          },
                          body: jsonEncode({
                            'title': titleController.text,
                            'author': authorController.text,
                            'description': descriptionController.text,
                          }),
                        );
                        var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

                        var request = http.MultipartRequest(
                          'POST',
                          Uri.parse('https://media.alexandrio.cloud/book/upload'),
                        );
                        request.files.add(
                          http.MultipartFile.fromBytes(
                            'book',
                            widget.bytes!,
                            filename: 'file.epub',
                            contentType: http.MediaType.parse('application/epub'),
                          ),
                        );
                        request.fields['book_id'] = jsonResponse['id'];
                        request.fields['library_id'] = widget.library.state.id;
                        request.headers['Authorization'] = 'Bearer ${clientState.token}';
                        var res = await request.send();
                        print(res);

                        await widget.library.books.refresh();
                        // if (res.statusCode == 204) {
                        // } else {
                        // }
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: kPadding.vertical * 1.25),
                      child: Center(child: Text('Confirm', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
