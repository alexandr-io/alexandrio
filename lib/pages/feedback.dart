import 'package:amberkit/amberkit.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '/api/alexandrio/alexandrio.dart' as alexandrio;

class FeedbackPage extends StatefulWidget {
  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  late alexandrio.ClientBloc client;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    client = BlocProvider.of<alexandrio.ClientBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Feedback'),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Feedback',
                ),
                maxLines: null,
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            var sentryId = await Sentry.captureMessage('User Feedback');

            final feedback = SentryUserFeedback(
              eventId: sentryId,
              comments: controller.text,
              // email: (client.state as alexandrio.ClientConnected).login,
              name: (client.state as alexandrio.ClientConnected).login,
            );

            await Sentry.captureUserFeedback(feedback);
          },
          label: Text('Submit feedback'),
          icon: Icon(Icons.send),
        ),
      );
}
