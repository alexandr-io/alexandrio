
import 'dart:convert';

import 'package:amberkit/amberkit.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_epub_reader/flutter_epub.dart';
import 'package:http/http.dart' as http;

import '/api/alexandrio/alexandrio.dart' as alexandrio;

class UserPage extends StatefulWidget {
  final String username;
  final String email;

  const UserPage({
    required this.username,
    required this.email
  });

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late alexandrio.ClientBloc client;
  late TextEditingController _previousPassword;
  late TextEditingController _resetPassword;
  late TextEditingController _confirmResetPassword;

  Future<bool> _changePassword() async {
    var realState = client.state as alexandrio.ClientConnected;
    var changePassword = await http.put(
      Uri.parse('https://auth.alexandrio.cloud/password/update'),
      headers: {
        'Authorization': 'Bearer ${realState.token}'
      },
      body: jsonEncode({
        'current_password': _previousPassword.text,
        'new_password': _resetPassword.text
      })
    );

    if (changePassword.statusCode != 200) {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    client = BlocProvider.of<alexandrio.ClientBloc>(context);
    _previousPassword = TextEditingController();
    _resetPassword = TextEditingController();
    _confirmResetPassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _previousPassword.dispose();
    _resetPassword.dispose();
    _confirmResetPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('User page')
    ),
    body: Padding(
        padding: EdgeInsets.all(kPadding.horizontal / 3.0) + EdgeInsets.symmetric(horizontal: kPadding.horizontal / 3.0),
        child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // color: Colors.red,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name',  style: Theme.of(context).textTheme.headline5!.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: kPadding.vertical * 0.25),
                Text(widget.username),
              ]
            )
          ),
          SizedBox(height: kPadding.vertical),
          Container(
            // color: Colors.blue,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email',  style: Theme.of(context).textTheme.headline5!.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: kPadding.vertical * 0.25),
                Text(widget.email),
              ]
            )
          ),
          SizedBox(height: kPadding.vertical),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.headline5!.copyWith(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              showDialog(
                context: context, 
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Reset your password'),
                    content: Column(
                      children: [
                        SizedBox(height: kPadding.vertical * 2),
                        TextField(

                        ),
                        SizedBox(height: kPadding.vertical),
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'New password'
                          ),
                          controller: _resetPassword
                        ),
                        // SizedBox(height: kPadding.vertical),
                        // TextField(
                        //   decoration: InputDecoration(
                        //     border: OutlineInputBorder(),
                        //     labelText: 'Confirm your new password'
                        //   ),
                        //   controller: _confirmResetPassword
                        // )
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          _previousPassword.clear();
                          _resetPassword.clear();
                          _confirmResetPassword.clear();
                          Navigator.pop(context, false);
                        },
                        child: const Text('Cancel')
                      ),
                      TextButton(
                        onPressed: () {
                          _changePassword();
                          _previousPassword.clear();
                          _resetPassword.clear();
                          _confirmResetPassword.clear();
                          Navigator.pop(context, true);
                        },
                        child: const Text('Reset password')
                      )
                    ],
                  );
                }
              );
            },
            child: const Text('Reset password')
          ),
          // Row(
          //   mainAxisSize: MainAxisSize.min,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     Container(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Column(
          //         children: [
          //           Text('Books',  style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold)),
          //           Text('10'),
          //         ],
          //       )
          //     ),
          //     Container(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Column(
          //         children: [
          //           Text('Libraries',  style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold)),
          //           Text('26')
          //         ],
          //       )
          //     )                
          //   ]
          // )
        ]
      )
      //  )
      // )  
    )
  );
}
