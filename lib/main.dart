import 'dart:io';

import 'package:alexandrio/offlinebook.dart';
import 'package:amberkit/amberkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dart_downloader/DownloadManager.dart';

import 'app.dart';
import 'api/alexandrio/alexandrio.dart' as alexandrio;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

  Hive.registerAdapter(OfflineBookAdapter());

  if (Platform.isIOS || Platform.isAndroid) {
    await Hive.initFlutter();
  } else {
    Hive.init('.');
  }

  var themeBox = await Hive.openBox('Theme');
  var booksBox = await Hive.openBox('Books');
  var accountBox = await Hive.openBox('Account');

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => alexandrio.ClientBloc(accountBox)),
        BlocProvider(create: (context) => ThemeBloc(themeBox, colorScheme: 'green', mode: ThemeMode.system)),
        BlocProvider(create: (context) => DownloadManager()),
      ],
      child: App(),
    ),
  );
}
