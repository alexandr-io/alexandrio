import 'package:alexandrio/pages/offline.dart';
import 'package:alexandrio/pages/settings.dart';
import 'package:amberkit/amberkit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'dart:ui';

import 'pages/update.dart';
import 'pages/home.dart';
import 'pages/login.dart';

class App extends StatelessWidget {
  final String? initialRoute;

  const App({
    Key? key,
    this.initialRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          if (state is ThemeLoaded) {
            return RouteManager(
              builder: (context, routeManager) => MaterialApp(
                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: [
                  Locale('en'),
                  Locale('fr'),
                ],
                locale: Locale('en'),
                title: 'Alexandrio',
                onGenerateTitle: (context) => 'Alexandrio',
                initialRoute: initialRoute ?? routeManager.initialRoute,
                onGenerateInitialRoutes: routeManager.onGenerateInitialRoutes,
                onGenerateRoute: routeManager.onGenerateRoute,
                darkTheme: ThemeManager.buildTheme(Brightness.dark, state.colorScheme),
                theme: ThemeManager.buildTheme(Brightness.light, state.colorScheme),
                themeMode: state.mode,
                debugShowCheckedModeBanner: false,
              ),
              initialRoute: '/login',
              routes: {
                '/update': () => UpdatePage(),
                '/login': () => LoginPage(),
                '/settings': () => SettingsPage(),
                '/offline': () => OfflinePage(),
                '/': () => HomePage(),
              },
            );
          }

          return Center(child: CircularProgressIndicator.adaptive());
        },
      );
}
