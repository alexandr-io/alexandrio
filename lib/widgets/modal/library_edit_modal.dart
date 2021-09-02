import 'package:amberkit/amberkit.dart';
import 'package:flutter/material.dart';

class LibraryEditModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        // shrinkWrap: true,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: kPadding.vertical),
          Center(
            child: Text('Edit Library 1', style: Theme.of(context).textTheme.headline6),
          ),
          SizedBox(height: kPadding.vertical),
          SizedBox(
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: kPadding.vertical * 1.25),
                      child: Center(child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold))),
                    ),
                  ),
                ),
                Container(height: kPadding.vertical * 2.0, width: 1.0, color: Theme.of(context).dividerColor),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: kPadding.vertical * 1.25),
                      child: Center(child: Text('Confirm', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
