import 'package:amberkit/amberkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/api/alexandrio/alexandrio.dart' as alexandrio;

class BookDeleteModal extends StatelessWidget {
  final alexandrio.Book book;
  final alexandrio.LibraryCubit library;

  const BookDeleteModal({
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
          Center(
            child: Text('Delete ${book.title} from ${library.state.title}?', style: Theme.of(context).textTheme.headline6),
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
                    onTap: () {
                      Navigator.of(context).pop();
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