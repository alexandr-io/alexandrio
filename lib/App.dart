import 'package:amberkit/amberkit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              initialRoute: '/update',
              routes: {
                '/update': () => UpdatePage(),
                '/login': () => LoginPage(),
                '/': () => HomePage(),
              },
            );
          }

          return Center(child: CircularProgressIndicator.adaptive());
        },
      );
}
