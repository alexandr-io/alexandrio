import 'package:amberkit/amberkit.dart';
import 'package:flutter/material.dart';

import '/api/alexandrio/alexandrio.dart' as alexandrio;

class BookCreateUpdateModal extends StatefulWidget {
  final alexandrio.BookCubit? book;
  final alexandrio.LibraryCubit library;

  const BookCreateUpdateModal({
    Key? key,
    this.book,
    required this.library,
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
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.book?.emit(alexandrio.Book(
                        title: titleController.text,
                        author: authorController.text,
                        description: descriptionController.text,
                      ));
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
