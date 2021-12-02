import 'package:amberkit/amberkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '/api/alexandrio/alexandrio.dart' as alexandrio;

class BookDeleteModal extends StatelessWidget {
  final alexandrio.BookCubit book;
  final alexandrio.LibraryCubit library;
  final alexandrio.ClientBloc client;

  const BookDeleteModal({
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
            child: Text('Delete ${book.state.title} from ${library.state.title}?', style: Theme.of(context).textTheme.headline6),
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
                      var response = await http.delete(
                        Uri.parse('https://library.alexandrio.cloud/library/${library.state.id}/book/${book.state.id}'),
                        headers: {
                          'Content-Type': 'application/json',
                          'Authorization': 'Bearer ${clientState.token}',
                        },
                      );
                      if (response.statusCode != 204) {
                        messenger.showSnackBar(SnackBar(
                          content: Text('Couldn\'t delete book'),
                        ));
                      } else {
                        await library.books.refresh();
                        // clientState.libraries.delete(library);
                        // await clientState.libraries.refresh();
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: kPadding.vertical * 1.25),
                      child: Center(child: Text('Delete', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
