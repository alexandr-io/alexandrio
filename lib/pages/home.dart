import 'package:amberkit/amberkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/widgets/modal/library_modal.dart';
import '/widgets/modal/book_create_update_modal.dart';
import '/widgets/modal/book_modal.dart';
import '/widgets/modal/library_create_update_modal.dart';
import '/api/alexandrio/alexandrio.dart' as alexandrio;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late alexandrio.ClientBloc client;
  late alexandrio.LibrariesCubit libraries;

  @override
  void initState() {
    client = BlocProvider.of<alexandrio.ClientBloc>(context);
    libraries = alexandrio.LibrariesCubit(client);
    client.stream.listen((event) {
      if (event is alexandrio.ClientDisconnected) Navigator.of(context).pushReplacementNamed('/login');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            BottomModal.show(context: context, child: LibraryCreateUpdateModal());
          },
          child: Icon(Icons.add),
        ),
        body: BlocBuilder<alexandrio.LibrariesCubit, List<alexandrio.LibraryCubit>?>(
          bloc: libraries,
          builder: (context, state) {
            return ListView(
              children: [
                Container(
                  height: kPadding.vertical * 4.0,
                  child: Row(
                    children: [
                      SizedBox(width: kPadding.horizontal),
                      Text('Welcome, \$username!', style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold)),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.logout),
                        onPressed: () {
                          BlocProvider.of<alexandrio.ClientBloc>(context).add(alexandrio.ClientDisconnect());
                        },
                      ),
                      SizedBox(width: kPadding.horizontal),
                    ],
                  ),
                ),
                if (state != null)
                  for (var library in state) LibraryDisplay(library: library),
              ],
            );
          },
        ),
      );
}

class LibraryDisplay extends StatelessWidget {
  final alexandrio.LibraryCubit library;

  const LibraryDisplay({
    Key? key,
    required this.library,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<alexandrio.LibraryCubit, alexandrio.Library>(
      bloc: library,
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: kPadding.vertical),
            InkWell(
              onTap: () {
                BottomModal.show(
                  context: context,
                  child: LibraryModal(library: library),
                );
              },
              onLongPress: () {
                BottomModal.show(context: context, child: LibraryCreateUpdateModal(library: library));
              },
              child: Padding(
                padding: EdgeInsets.all(kPadding.horizontal / 3.0) + EdgeInsets.symmetric(horizontal: kPadding.horizontal / 3.0),
                child: Row(
                  children: [
                    Container(height: kPadding.vertical * 2.0, width: kPadding.horizontal * 0.1, color: Theme.of(context).colorScheme.primary),
                    SizedBox(width: kPadding.horizontal * 0.25),
                    Text(state.title, style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold)),
                    Spacer(),
                    // Icon(Icons.chevron_right),
                    Icon(Icons.more_horiz),
                  ],
                ),
              ),
            ),
            BlocBuilder<alexandrio.BooksCubit, List<alexandrio.BookCubit>?>(
              bloc: library.books,
              builder: (context, state) {
                return SizedBox(
                  height: 128.0 * 1.5,
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: kPadding.horizontal / 3.0),
                    scrollDirection: Axis.horizontal,
                    children: [
                      if (state == null)
                        Padding(
                          padding: kPadding,
                          child: Center(child: CircularProgressIndicator.adaptive()),
                        ),
                      if (state != null) ...[
                        for (var book in state) BookWidget(book: book, library: library),
                      ],
                      Padding(
                        padding: kPadding * 0.5,
                        child: AspectRatio(
                          aspectRatio: 10.0 / 16.0,
                          child: OutlinedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: kBorderRadiusCircular)),
                            ),
                            onPressed: () {
                              BottomModal.show(context: context, child: BookCreateUpdateModal(library: library));
                            },
                            child: Icon(Icons.add),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class BookWidget extends StatelessWidget {
  final alexandrio.BookCubit book;
  final alexandrio.LibraryCubit library;

  const BookWidget({
    Key? key,
    required this.book,
    required this.library,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<alexandrio.BookCubit, alexandrio.Book>(
      bloc: book,
      builder: (context, state) => Padding(
        padding: kPadding * 0.5,
        child: AspectRatio(
          aspectRatio: 10.0 / 16.0,
          child: Material(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: kBorderRadiusCircular,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                BottomModal.show(context: context, child: BookModal(book: book, library: library));
              },
              onLongPress: () {
                BottomModal.show(context: context, child: BookCreateUpdateModal(book: book, library: library));
              },
              child: Center(
                child: Text(state.title),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
