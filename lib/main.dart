import 'package:amberkit/amberkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dart_downloader/DownloadManager.dart';

import 'app.dart';
import 'login/login_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

  await Hive.initFlutter();
  var themeBox = await Hive.openBox('Theme');

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginBloc()),
        BlocProvider(create: (context) => ThemeBloc(themeBox)),
        BlocProvider(create: (context) => DownloadManager()),
      ],
      child: App(),
    ),
  );
}
