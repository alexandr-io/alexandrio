import 'package:amberkit/amberkit.dart';
import 'package:flutter/material.dart';

class UpdateModal extends StatelessWidget {
  final UpdateProvider updateProvider;
  final UpdateRelease updateRelease;

  const UpdateModal({
    Key? key,
    required this.updateProvider,
    required this.updateRelease,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
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
                  Text('Latest version: ${updateRelease.name}', style: Theme.of(context).textTheme.headline5),
                  Text(updateRelease.publishedAt.toString(), style: Theme.of(context).textTheme.bodyText1),
                  SizedBox(height: kPadding.bottom),
                  FutureBuilder<String>(
                    future: updateProvider.getReleaseDescription(updateRelease),
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
      );
}
