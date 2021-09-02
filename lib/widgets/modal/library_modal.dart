import '/widgets/modal/library_delete_modal.dart';
import '/widgets/modal/library_edit_modal.dart';
import 'package:amberkit/amberkit.dart';
import 'package:flutter/material.dart';

class LibraryModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        // shrinkWrap: true,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: kPadding.vertical),
          Center(
            child: Text('Library 1', style: Theme.of(context).textTheme.headline6),
          ),
          SizedBox(height: kPadding.vertical),
          Tile(
            leading: Icon(Icons.edit),
            title: 'Edit',
            onTap: () {
              Navigator.of(context).pop();
              BottomModal.show(context: context, child: LibraryEditModal());
            },
          ),
          Tile(
            leading: Icon(Icons.delete),
            title: 'Delete',
            onTap: () {
              Navigator.of(context).pop();
              BottomModal.show(context: context, child: LibraryDeleteModal());
            },
          ),
        ],
      );
}
