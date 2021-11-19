import 'package:alexandrio/widgets/modal/update_modal.dart';
import 'package:amberkit/amberkit.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

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
  final UpdateProvider updateProvider = UpdateProvider(owner: 'alexandr-io', repositoryName: 'alexandrio');

  @override
  void initState() {
    client = BlocProvider.of<alexandrio.ClientBloc>(context);
    client.stream.listen((event) {
      if (event is alexandrio.ClientDisconnected) Navigator.of(context).pushReplacementNamed('/login');
    });
    updateProvider.getLatestRelease().then((release) async {
      var packageInfo = await PackageInfo.fromPlatform();
      var releaseVersion = Version.parse(release.tagName);
      var currentVersion = Version.parse('${packageInfo.version}+${packageInfo.buildNumber}');
      if (currentVersion < releaseVersion) {
        await BottomModal.show(
          context: context,
          child: UpdateModal(updateProvider: updateProvider, updateRelease: release),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Alexandrio'),
          centerTitle: true,
          // foregroundColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: [
            IconButton(
              icon: Icon(Icons.feedback),
              onPressed: () {
                Navigator.of(context).pushNamed('/feedback');
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).pushNamed('/settings');
              },
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                client.add(alexandrio.ClientDisconnect());
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            BottomModal.show(context: context, child: LibraryCreateUpdateModal(client: client));
          },
          child: Icon(Icons.add),
        ),
        body: BlocBuilder<alexandrio.ClientBloc, alexandrio.ClientState>(
          builder: (context, state2) {
            if (state2 is alexandrio.ClientConnected) {
              return BlocBuilder<alexandrio.LibrariesCubit, List<alexandrio.LibraryCubit>?>(
                bloc: state2.libraries,
                builder: (context, state) {
                  return RefreshIndicator(
                    onRefresh: () {
                      return state2.libraries.refresh();
                    },
                    child: ListView(
                      children: [
                        // Container(
                        //   height: kPadding.vertical * 4.0,
                        //   child: Row(
                        //     children: [
                        //       SizedBox(width: kPadding.horizontal),
                        //       Text('Welcome, \$username!', style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold)),
                        //       Spacer(),
                        //       IconButton(
                        //         icon: Icon(Icons.logout),
                        //         onPressed: () {
                        //           client.add(alexandrio.ClientDisconnect());
                        //         },
                        //       ),
                        //       SizedBox(width: kPadding.horizontal),
                        //     ],
                        //   ),
                        // ),
                        if (state != null)
                          for (var library in state) LibraryDisplay(client: client, library: library),
                      ],
                    ),
                  );
                },
              );
            }
            return CircularProgressIndicator.adaptive();
          },
        ),
      );
}

class LibraryDisplay extends StatelessWidget {
  final alexandrio.ClientBloc client;
  final alexandrio.LibraryCubit library;

  const LibraryDisplay({
    Key? key,
    required this.client,
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
                  child: LibraryModal(client: client, library: library),
                );
              },
              onLongPress: () {
                BottomModal.show(context: context, child: LibraryCreateUpdateModal(client: client, library: library));
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
                        for (var book in state) BookWidget(client: client, book: book, library: library),
                      ],
                      Padding(
                        padding: kPadding * 0.5,
                        child: AspectRatio(
                          aspectRatio: 10.0 / 16.0,
                          child: OutlinedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: kBorderRadiusCircular)),
                            ),
                            onPressed: () async {
                              var file = await FilePickerCross.importFromStorage(
                                type: FileTypeCross.custom,
                                fileExtension: 'pdf, epub',
                              );
                              await BottomModal.show(context: context, child: BookCreateUpdateModal(client: client, bytes: file.toUint8List(), library: library));
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
  final alexandrio.ClientBloc client;
  final alexandrio.BookCubit book;
  final alexandrio.LibraryCubit library;

  const BookWidget({
    Key? key,
    required this.client,
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
            elevation: 1.0,
            color: Theme.of(context).colorScheme.surface,
            borderRadius: kBorderRadiusCircular,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                BottomModal.show(context: context, child: BookModal(client: client, book: book, library: library));
              },
              onLongPress: () {
                BottomModal.show(context: context, child: BookCreateUpdateModal(client: client, book: book, library: library));
              },
              child: state.thumbnail != null
                  ? Image.network(
                      state.thumbnail!,
                      fit: BoxFit.cover,
                      isAntiAlias: true,
                      filterQuality: FilterQuality.high,
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          state.title,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
