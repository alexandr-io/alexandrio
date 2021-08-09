import 'package:amberkit/constants.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amberAccent,
          title: Text('Test - ${textController.text.length} characters, ${textController.text.split(' ').where((x) => x.isNotEmpty).length} words, reading time: ${Duration(seconds: (textController.text.split(' ').where((x) => x.isNotEmpty).length / 3.333).floor())}'),
        ),
        body: Padding(
          padding: kPadding,
          child: TextField(
            controller: textController,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            maxLines: null,
            onChanged: (text) => setState(() {}),
          ),
        ),
      );
}
