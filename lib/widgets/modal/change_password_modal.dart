import 'dart:convert';

import 'package:amberkit/amberkit.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '/api/alexandrio/alexandrio.dart' as alexandrio;

class ChangePasswordModal extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController oldController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final String token;

  ChangePasswordModal({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        // shrinkWrap: true,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: kPadding.vertical),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kPadding.horizontal),
            child: Text('Change password', style: Theme.of(context).textTheme.headline6),
          ),
          SizedBox(height: kPadding.vertical),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kPadding.horizontal),
            child: TextField(
              controller: oldController,
              decoration: InputDecoration(
                labelText: 'Old password',
                filled: true,
              ),
            ),
          ),
          SizedBox(height: kPadding.vertical),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kPadding.horizontal),
            child: TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'New password',
                filled: true,
              ),
            ),
          ),
          SizedBox(height: kPadding.vertical / 2.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kPadding.horizontal),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0.0),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: kBorderRadiusCircular)),
                  padding: MaterialStateProperty.all(kPadding * 2.0),
                ),
                onPressed: () async {
                  var response = await http.put(
                    Uri.parse('https://auth.preprod.alexandrio.cloud/password/update'),
                    headers: {
                      'Content-Type': 'application/json',
                      'Authorization': 'Bearer $token',
                    },
                    body: jsonEncode(
                      {
                        'current_password': oldController.text,
                        'new_password': passwordController.text,
                      },
                    ),
                  );
                  print('${response.statusCode} - ${response.body}');
                  var client = BlocProvider.of<alexandrio.ClientBloc>(context);
                  client.add(alexandrio.ClientDisconnect());
                },
                child: Text('Reset password'),
              ),
            ),
          ),
          SizedBox(height: kPadding.vertical),
        ],
      );
}
