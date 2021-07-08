import 'dart:async';

import 'package:alexandrio/Pages/Settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../UpdateModal.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    // @required this.client,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<bool>? updateFuture;

  @override
  void initState() {
    updateFuture = UpdateModal.hasUpdate();

    Timer.periodic(Duration(minutes: 5), (timer) {
      print('Checking for updates...');
      setState(() {
        updateFuture = UpdateModal.hasUpdate();
      });
    });

    SchedulerBinding.instance!.addPostFrameCallback((_) async {
      UpdateModal.searchForUpdate(context);
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Alexandrio'),
          actions: [
            FutureBuilder<bool>(
              future: updateFuture,
              builder: (context, future) => future.hasData && future.data == true
                  ? IconButton(
                      icon: Icon(
                        Icons.system_update,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () async => UpdateModal.searchForUpdate(context),
                    )
                  : SizedBox(),
            ),
            IconButton(
              icon: Icon(
                Icons.system_update,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () async => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              ),
            ),
          ],
        ),
      );
}
