import 'package:amberkit/amberkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/api/alexandrio/alexandrio.dart' as alexandrio;
import '/widgets/modal/library_modal.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    BlocProvider.of<alexandrio.ClientBloc>(context).stream.listen((event) {
      if (event is alexandrio.ClientDisconnected) Navigator.of(context).pushReplacementNamed('/login');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ListView(
          children: [
            Container(
              height: kPadding.vertical * 4.0,
              child: Row(
                children: [
                  SizedBox(width: kPadding.horizontal),
                  Text('Welcome, \$username!', style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold)),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () {
                      BlocProvider.of<alexandrio.ClientBloc>(context).add(alexandrio.ClientDisconnect());
                    },
                  ),
                  SizedBox(width: kPadding.horizontal),
                ],
              ),
            ),
            LibraryDisplay(),
            LibraryDisplay(),
            LibraryDisplay(),
            LibraryDisplay(),
            LibraryDisplay(),
            LibraryDisplay(),
          ],
        ),
        // appBar: AppBar(
        //   backgroundColor: Colors.amberAccent,
        //   title: Text('Test - ${textController.text.length} characters, ${textController.text.split(' ').where((x) => x.isNotEmpty).length} words, reading time: ${Duration(seconds: (textController.text.split(' ').where((x) => x.isNotEmpty).length / 3.333).floor())}'),
        // ),
        // body: Padding(
        //   padding: kPadding,
        //   child: TextField(
        //     controller: textController,
        //     decoration: InputDecoration(
        //       border: InputBorder.none,
        //     ),
        //     maxLines: null,
        //     onChanged: (text) => setState(() {}),
        //   ),
        // ),
      );
}

class LibraryDisplay extends StatelessWidget {
  const LibraryDisplay({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: kPadding.vertical),
        InkWell(
          onTap: () {
            BottomModal.show(
              context: context,
              child: LibraryModal(),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(kPadding.horizontal / 3.0) + EdgeInsets.symmetric(horizontal: kPadding.horizontal / 3.0),
            child: Row(
              children: [
                Container(height: kPadding.vertical * 2.0, width: kPadding.horizontal * 0.1, color: Theme.of(context).colorScheme.primary),
                SizedBox(width: kPadding.horizontal * 0.25),
                Text('Library 1', style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold)),
                Spacer(),
                // Icon(Icons.chevron_right),
                Icon(Icons.more_horiz),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 128.0 * 1.5,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: kPadding.horizontal / 3.0),
            scrollDirection: Axis.horizontal,
            children: [
              BookWidget(),
              BookWidget(),
              Padding(
                padding: kPadding * 0.5,
                child: AspectRatio(
                  aspectRatio: 9.0 / 16.0,
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Icon(Icons.add),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BookWidget extends StatelessWidget {
  const BookWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kPadding * 0.5,
      child: AspectRatio(
        aspectRatio: 9.0 / 16.0,
        child: Material(
          color: Colors.blue,
        ),
      ),
    );
  }
}
