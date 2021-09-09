import 'dart:convert';

import 'package:amberkit/amberkit.dart';
import 'package:flutter/material.dart';
import '/api/alexandrio/alexandrio.dart' as alexandrio;

import 'package:http/http.dart' as http;

class LibraryCreateUpdateModal extends StatefulWidget {
  final alexandrio.ClientBloc client;
  final alexandrio.LibraryCubit? library;

  const LibraryCreateUpdateModal({
    Key? key,
    this.library,
    required this.client,
  }) : super(key: key);

  @override
  State<LibraryCreateUpdateModal> createState() => _LibraryCreateUpdateModalState();
}

class _LibraryCreateUpdateModalState extends State<LibraryCreateUpdateModal> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    titleController = TextEditingController(text: widget.library?.state.title);
    descriptionController = TextEditingController(text: widget.library?.state.description);
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
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
            child: Text(widget.library == null ? 'Create Library' : 'Edit ${widget.library!.state.title}', style: Theme.of(context).textTheme.headline6),
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
          // SizedBox(height: kPadding.vertical),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: kPadding.horizontal),
          //   child: TextField(
          //     controller: descriptionController,
          //     decoration: InputDecoration(
          //       labelText: 'Description',
          //       filled: true,
          //     ),
          //   ),
          // ),
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
                      if (widget.library != null) {
                        widget.library!.emit(alexandrio.Library(
                          id: widget.library!.state.id,
                          title: titleController.text,
                          description: descriptionController.text,
                        ));
                      } else {
                        var clientState = widget.client.state as alexandrio.ClientConnected;
                        var response = await http.post(
                          Uri.parse('https://library.alexandrio.cloud/library'),
                          headers: {
                            'Content-Type': 'application/json',
                            'Authorization': 'Bearer ${clientState.token}',
                          },
                          body: jsonEncode({
                            'name': titleController.text,
                            'description': descriptionController.text,
                          }),
                        );
                        if (response.statusCode != 201) {
                          messenger.showSnackBar(SnackBar(
                            content: Text('Couldn\'t create library'),
                          ));
                        } else {
                          var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
                          clientState.libraries.add(alexandrio.Library(
                            id: jsonResponse['id'],
                            title: jsonResponse['name'],
                            description: jsonResponse['description'],
                          ));
                        }
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
