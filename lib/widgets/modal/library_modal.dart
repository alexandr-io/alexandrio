import 'package:amberkit/amberkit.dart';
import 'package:flutter/material.dart';

import '/widgets/modal/library_delete_modal.dart';
import 'library_create_update_modal.dart';
import '/api/alexandrio/alexandrio.dart' as alexandrio;

class LibraryModal extends StatelessWidget {
  final alexandrio.ClientBloc client;
  final alexandrio.LibraryCubit library;

  const LibraryModal({
    Key? key,
    required this.client,
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
            child: Text(library.state.title, style: Theme.of(context).textTheme.headline6),
          ),
          SizedBox(height: kPadding.vertical),
          // Tile(
          //   leading: Icon(Icons.edit),
          //   title: 'Edit',
          //   onTap: () {
          //     Navigator.of(context).pop();
          //     BottomModal.show(context: context, child: LibraryCreateUpdateModal(client: client, library: library));
          //   },
          // ),
          Tile(
            leading: Icon(Icons.delete),
            title: 'Delete',
            onTap: () {
              Navigator.of(context).pop();
              BottomModal.show(context: context, child: LibraryDeleteModal(client: client, library: library));
            },
          ),
        ],
      );
}
