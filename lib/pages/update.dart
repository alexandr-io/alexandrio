import 'package:amberkit/amberkit.dart';
import 'package:flutter/material.dart';

class UpdatePage extends StatefulWidget {
  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final UpdateProvider updateProvider = UpdateProvider(owner: 'alexandr-io', repositoryName: 'alexandrio');
  late Future<UpdateRelease> updateRelease;

  @override
  void initState() {
    updateRelease = updateProvider.getLatestRelease();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ListView(
          children: [
            UpdateCard(updateRelease: updateRelease, updateProvider: updateProvider),
          ],
        ),
      );
}

class UpdateCard extends StatelessWidget {
  const UpdateCard({
    Key? key,
    required this.updateRelease,
    required this.updateProvider,
  }) : super(key: key);

  final Future<UpdateRelease> updateRelease;
  final UpdateProvider updateProvider;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UpdateRelease>(
      future: updateRelease,
      builder: (BuildContext context, AsyncSnapshot<UpdateRelease> snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: kPadding,
            child: Material(
              elevation: 2.0,
              borderRadius: kBorderRadiusCircular,
              color: Theme.of(context).colorScheme.surface,
              child: Padding(
                padding: kPadding,
                child: Row(
                  children: [
                    Icon(Icons.update),
                    SizedBox(width: kPadding.right),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Latest version: ${snapshot.data!.name}', style: Theme.of(context).textTheme.headline5),
                          Text(snapshot.data!.publishedAt.toString(), style: Theme.of(context).textTheme.bodyText1),
                          SizedBox(height: kPadding.bottom),
                          FutureBuilder<String>(
                            future: updateProvider.getReleaseDescription(snapshot.data!),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) return Text(snapshot.data!.trim());
                              return Center(child: CircularProgressIndicator.adaptive());
                            },
                          ),
                          // for (var file in snapshot.data!.files) Text(file.name),
                        ],
                      ),
                    ),
                    SizedBox(width: kPadding.left),
                    ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0.0),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: kBorderRadiusCircular)),
                        padding: MaterialStateProperty.all(kPadding * 2.0),
                      ),
                      onPressed: () {},
                      child: Text('Update'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Center(child: CircularProgressIndicator.adaptive());
      },
    );
  }
}
