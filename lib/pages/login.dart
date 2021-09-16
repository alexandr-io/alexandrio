import 'dart:async';
import 'dart:convert';

import 'package:alexandrio/widgets/modal/forgot_password_modal.dart';
import 'package:amberkit/amberkit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/api/alexandrio/alexandrio.dart' as alexandrio;
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool register = false;
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController inviteController = TextEditingController();
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
    emailController.dispose();
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
                  child: Padding(
                    padding: kPadding,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: kPadding,
                          child: Icon(Icons.book, size: 128.0),
                        ),
                        SizedBox(height: kPadding.vertical),
                        if (state is alexandrio.ClientErrored) ...[
                          Text(
                            'An error has occured',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text('${state.error}', textAlign: TextAlign.center),
                          // SizedBox(height: kPadding.vertical),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0.0),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: kBorderRadiusCircular)),
                                padding: MaterialStateProperty.all(kPadding * 2.0),
                              ),
                              onPressed: () {
                                BlocProvider.of<alexandrio.ClientBloc>(context).emit(alexandrio.ClientDisconnected());
                              },
                              child: Text('Back'),
                            ),
                          ),
                        ],
                        if (state is alexandrio.ClientDisconnected) ...[
                          TextField(
                            decoration: InputDecoration(
                              filled: true,
                              labelText: AppLocalizations.of(context)?.username ?? 'Username',
                            ),
                            controller: loginController,
                          ),
                          SizedBox(height: kPadding.vertical),
                          TextField(
                            decoration: InputDecoration(
                              filled: true,
                              labelText: AppLocalizations.of(context)?.password ?? 'Password',
                            ),
                            controller: passwordController,
                            obscureText: true,
                          ),
                          if (register) ...[
                            SizedBox(height: kPadding.vertical),
                            TextField(
                              decoration: InputDecoration(
                                filled: true,
                                labelText: 'Email',
                              ),
                              controller: emailController,
                            ),
                            SizedBox(height: kPadding.vertical),
                            TextField(
                              decoration: InputDecoration(
                                filled: true,
                                labelText: 'Invite Code',
                                suffixIcon: kDebugMode
                                    ? IconButton(
                                        icon: Icon(Icons.celebration_rounded),
                                        onPressed: () async {
                                          var response = await http.get(Uri.parse('https://auth.alexandrio.cloud/invitation/new'));
                                          if (response.statusCode != 200) return;
                                          var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
                                          setState(() {
                                            inviteController.text = jsonResponse['token'];
                                          });
                                        },
                                      )
                                    : null,
                              ),
                              controller: inviteController,
                            ),
                          ],
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
                                if (register) {
                                  BlocProvider.of<alexandrio.ClientBloc>(context).add(alexandrio.ClientRegister(loginController.text, passwordController.text, emailController.text, inviteController.text));
                                } else {
                                  BlocProvider.of<alexandrio.ClientBloc>(context).add(alexandrio.ClientConnect(loginController.text, passwordController.text));
                                }
                              },
                              child: Text(register ? ('Register') : (AppLocalizations.of(context)?.login ?? 'Login')),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0.0),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: kBorderRadiusCircular)),
                                padding: MaterialStateProperty.all(kPadding * 2.0),
                              ),
                              onPressed: () {
                                // Navigator.of(context).pushNamedAndRemoveUntil('/register', (route) => false);'
                                setState(() {
                                  register = !register;
                                });
                              },
                              child: Text(register ? 'Login to existing account' : (AppLocalizations.of(context)?.registerAnAccount ?? 'Register an account')),
                            ),
                          ),
                          if (!register)
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0.0),
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: kBorderRadiusCircular)),
                                  padding: MaterialStateProperty.all(kPadding * 2.0),
                                ),
                                onPressed: () {
                                  BottomModal.show(context: context, child: ForgotPasswordModal());
                                  // BlocProvider.of<alexandrio.ClientBloc>(context).add(alexandrio.ClientConnect(loginController.text, passwordController.text));
                                },
                                child: Text(AppLocalizations.of(context)?.forgotPassword ?? 'Forgot password?'), // Text(),
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
        ),
      );
}
