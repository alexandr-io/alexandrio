import 'dart:async';

import 'package:alexandrio/api/alexandrio/alexandrio.dart' as alexandrio;
import 'package:amberkit/amberkit.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late StreamSubscription sub;

  @override
  void initState() {
    sub = BlocProvider.of<alexandrio.ClientBloc>(context).stream.listen((event) {
      if (event is alexandrio.ClientConnected) Navigator.of(context).pushReplacementNamed('/');
    });
    super.initState();
  }

  @override
  void dispose() {
    sub.cancel();
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: BlocBuilder<alexandrio.ClientBloc, alexandrio.ClientState>(
          builder: (context, state) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 128.0 * 2.5,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: kPadding,
                        child: Icon(Icons.book, size: 128.0),
                      ),
                      SizedBox(height: kPadding.vertical),
                      if (state is alexandrio.ClientDisconnected) ...[
                        TextField(
                          decoration: InputDecoration(
                            filled: true,
                            labelText: 'Login',
                          ),
                          controller: loginController,
                        ),
                        SizedBox(height: kPadding.vertical),
                        TextField(
                          decoration: InputDecoration(
                            filled: true,
                            labelText: 'Password',
                          ),
                          controller: passwordController,
                          obscureText: true,
                        ),
                        SizedBox(height: kPadding.vertical),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0.0),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: kBorderRadiusCircular)),
                              padding: MaterialStateProperty.all(kPadding * 2.0),
                            ),
                            onPressed: () {
                              BlocProvider.of<alexandrio.ClientBloc>(context).add(alexandrio.ClientConnect(loginController.text, passwordController.text));
                            },
                            child: Text('Login'),
                          ),
                        ),
                      ],
                      if (state is alexandrio.ClientConnected) ...[
                        SizedBox(height: kPadding.vertical),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0.0),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: kBorderRadiusCircular)),
                              padding: MaterialStateProperty.all(kPadding * 2.0),
                            ),
                            onPressed: () {
                              BlocProvider.of<alexandrio.ClientBloc>(context).add(alexandrio.ClientDisconnect());
                            },
                            child: Text('Disconnect'),
                          ),
                        ),
                      ],
                      if (state is alexandrio.ClientConnecting) ...[
                        Text('Connecting as ${state.login}'),
                        SizedBox(height: kPadding.vertical),
                        CircularProgressIndicator.adaptive(),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
