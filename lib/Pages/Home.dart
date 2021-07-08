import 'dart:async';

import 'package:flutter/material.dart';

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

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Alexandrio (build 2)'),
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
          ],
        ),
      );
}
