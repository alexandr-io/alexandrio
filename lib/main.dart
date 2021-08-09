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

  await Hive.initFlutter();
  var themeBox = await Hive.openBox('Theme');

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => alexandrio.ClientBloc()),
        BlocProvider(create: (context) => ThemeBloc(themeBox, colorScheme: 'red', mode: ThemeMode.dark)),
        BlocProvider(create: (context) => DownloadManager()),
      ],
      child: App(),
    ),
  );
}
