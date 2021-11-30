import 'dart:convert';

import 'package:amberkit/amberkit.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_epub_reader/flutter_epub.dart';
import 'package:http/http.dart' as http;

import '../widgets/modal/change_password_modal.dart';
import '/api/alexandrio/alexandrio.dart' as alexandrio;

class UserPage extends StatefulWidget {
  final String username;
  final String email;

  const UserPage({required this.username, required this.email});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late alexandrio.ClientBloc client;
  late alexandrio.ClientConnected realState;

  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _previousPassword;
  late TextEditingController _resetPassword;
  late TextEditingController _confirmResetPassword;

  int getBookCount() {
    var total = 0;

    for (var library in realState.libraries.state!) {
      total += library.books.state!.length;
    }

    return total;
  }

  @override
  void initState() {
    client = BlocProvider.of<alexandrio.ClientBloc>(context);
    _usernameController = TextEditingController(text: widget.username);
    _emailController = TextEditingController(text: widget.email);
    _previousPassword = TextEditingController();
    _resetPassword = TextEditingController();
    _confirmResetPassword = TextEditingController();
    realState = client.state as alexandrio.ClientConnected;
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _previousPassword.dispose();
    _resetPassword.dispose();
    _confirmResetPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('User page')),
        body: ListView(
          padding: EdgeInsets.all(8.0),
          children: [
            TextField(
              controller: _usernameController,
              readOnly: true,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _emailController,
              readOnly: true,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 8.0),
            OutlinedButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.all(16.0)),
              ),
              onPressed: () {
                var realState = client.state as alexandrio.ClientConnected;
                BottomModal.show(
                  child: ChangePasswordModal(
                    token: realState.token,
                  ),
                  context: context,
                );
              },
              child: Text('Reset password'),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('Books', style: Theme.of(context).textTheme.headline5),
                      Text('${getBookCount()}', style: Theme.of(context).textTheme.headline6),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text('Libraries', style: Theme.of(context).textTheme.headline5),
                      Text('${realState.libraries.state!.length}', style: Theme.of(context).textTheme.headline6),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
