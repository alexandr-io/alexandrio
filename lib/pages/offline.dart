import 'package:amberkit/amberkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_epub_reader/flutter_epub_reader.dart';
import 'package:flutter_pdf_parser/flutter_pdf_parser.dart';

import '../offlinebook.dart';

class OfflinePage extends StatefulWidget {
  @override
  _OfflinePageState createState() => _OfflinePageState();
}

class _OfflinePageState extends State<OfflinePage> {
  late Future<Box> box;

  @override
  void initState() {
    box = Hive.openBox('Books');
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Alexandrio (Offline)'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: FutureBuilder<Box>(
            future: box,
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return ListView(
                  children: [
                    for (var item in List<OfflineBook>.from(snapshot.data!.values))
                      Tile(
                        title: '${item.title}',
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => item.format == 'application/pdf'
                                  ? PDFBook(
                                      token: '',
                                      book: item.id,
                                      library: item.libraryId,
                                      bytes: item.bytes,
                                      title: item.title,
                                      progress: null,
                                    )
                                  : EPUBBook(
                                      token: '',
                                      book: item.id,
                                      library: item.libraryId,
                                      bytes: item.bytes,
                                      title: item.title,
                                      progress: null,
                                    ),
                            ),
                          );
                        },
                      ),
                  ],
                );
              }
              return CircularProgressIndicator.adaptive();
            }),
      );
}
