import 'dart:io';

import 'package:alexandrio/Theme/ThemeBloc.dart';
import 'package:dart_downloader/DownloadManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'App.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid || Platform.isIOS) {
    await Hive.initFlutter();
  } else {
    Hive.init('.');
  }

  var themeBox = await Hive.openBox('Theme');

  // timeDilation = 4.0;

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => ThemeBloc(themeBox, mode: ThemeMode.dark, colorScheme: 'cyan')),
        BlocProvider(create: (BuildContext context) => DownloadManager()),
      ],
      child: App(),
    ),
  );
  // await Hive.close();
}
