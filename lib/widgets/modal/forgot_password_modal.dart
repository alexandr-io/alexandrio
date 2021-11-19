import 'dart:convert';

import 'package:amberkit/amberkit.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class ForgotPasswordModal extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) => Column(
        // shrinkWrap: true,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: kPadding.vertical),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kPadding.horizontal),
            child: Text('Reset password', style: Theme.of(context).textTheme.headline6),
          ),
          SizedBox(height: kPadding.vertical),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kPadding.horizontal),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
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
                  var response = await http.post(
                    Uri.parse('https://auth.preprod.alexandrio.cloud/password/reset'),
                    headers: {
                      'Content-Type': 'application/json',
                    },
                    body: jsonEncode({
                      'email': emailController.text,
                    }),
                  );
                  print('${response.statusCode} - ${response.body}');
                },
                child: Text('Request reset code'),
              ),
            ),
          ),
          SizedBox(height: kPadding.vertical * 2.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kPadding.horizontal),
            child: TextField(
              controller: codeController,
              decoration: InputDecoration(
                labelText: 'Reset code',
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
                    Uri.parse('https://auth.preprod.alexandrio.cloud/password/reset'),
                    headers: {
                      'Content-Type': 'application/json',
                    },
                    body: jsonEncode({
                      'new_password': passwordController.text,
                      'token': codeController.text,
                    }),
                  );
                  print('${response.statusCode} - ${response.body}');
                },
                child: Text('Reset password'),
              ),
            ),
          ),
          SizedBox(height: kPadding.vertical),
        ],
      );
}
