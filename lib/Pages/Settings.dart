import 'dart:io';
import 'dart:math';

import 'package:alexandrio/Components/UI/BlurModal.dart';
import 'package:alexandrio/Components/UI/NoAppBarBlur.dart';
import 'package:alexandrio/Components/UI/Tile.dart';
import 'package:alexandrio/Theme/ThemeBloc.dart';
import 'package:alexandrio/Theme/ThemeEvent.dart';
import 'package:alexandrio/Theme/ThemeManager.dart';
import 'package:alexandrio/Theme/ThemeState.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsEntry extends StatelessWidget {
  final String? category;
  final String title;
  final String? description;
  final Function(BuildContext context, String? category, String title, String? description) builder;

  const SettingsEntry({
    Key? key,
    this.category,
    required this.title,
    this.description,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => builder(context, category, title, description);
}

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => SizedBox.expand(child: child);

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: NoAppBarBlur(),
        body: Builder(
          builder: (context) {
            var entries = [
              SettingsEntry(
                category: 'Theme',
                title: 'Color',
                description: 'Change the primary color of the application',
                builder: (context, category, title, description) => Tile(
                  onTap: () async => BlurModal.show(
                    context: context,
                    child: BlocBuilder<ThemeBloc, ThemeState>(
                      builder: (context, state) => SafeArea(
                        child: SizedBox(
                          child: GridView.extent(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            maxCrossAxisExtent: 16.0 * 5.0,
                            children: [
                              for (var colorScheme in ThemeManager.colors.entries)
                                Tooltip(
                                  message: colorScheme.key,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(32.0),
                                      clipBehavior: Clip.antiAlias,
                                      color: colorScheme.value.first,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(32.0),
                                        onTap: () {
                                          BlocProvider.of<ThemeBloc>(context).add(ThemeColorSchemeChanged(colorScheme: colorScheme.key));
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      elevation: 2.0,
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(32.0),
                      clipBehavior: Clip.antiAlias,
                      child: SizedBox(width: 24.0, height: 24.0),
                    ),
                  ),
                  title: title,
                  subtitle: description,
                ),
              ),
              SettingsEntry(
                category: 'Theme',
                title: 'Brightness',
                description: 'Change between light and dark theme',
                builder: (context, category, title, description) => Tile(
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.wb_sunny_outlined),
                  ),
                  onTap: () => BlocProvider.of<ThemeBloc>(context).add(
                    ThemeModeChanged(
                      mode: (BlocProvider.of<ThemeBloc>(context).state as ThemeLoaded).mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
                    ),
                  ),
                  title: title,
                  subtitle: description,
                ),
              ),
              SettingsEntry(
                category: 'About',
                title: 'Show open-source licenses',
                description: 'Display the list of licenses used by dependencies',
                builder: (context, category, title, description) => Tile(
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.info),
                  ),
                  title: title,
                  subtitle: description,
                  onTap: () => showLicensePage(context: context),
                ),
              ),
              SettingsEntry(
                category: 'About',
                // title: 'Check for updates',
                title: 'About Alexandrio',
                description: 'Version',
                builder: (context, category, title, description) => FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) => Tile(
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.system_security_update),
                    ),
                    title: title,
                    subtitle: snapshot.hasData ? 'Running ${snapshot.data!.packageName} ${snapshot.data!.version}+${snapshot.data!.buildNumber}' : null,
                  ),
                ),
              ),
            ];

            var listChildren = [
              for (var entryGroup in groupBy<SettingsEntry, String?>(entries.where((entry) => (entry.category?.toLowerCase().contains(searchController.text.toLowerCase()) ?? false) || entry.title.toLowerCase().contains(searchController.text.toLowerCase()) || (entry.description?.toLowerCase().contains(searchController.text.toLowerCase()) ?? false)), (x) => x.category).entries) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 4.0),
                  child: Text(
                    '${entryGroup.key}',
                    style: Theme.of(context).textTheme.button!.copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                for (var entry in entryGroup.value) entry,
              ],
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ];

            return CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 128.0 * 1.5,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0) + EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24.0),
                          Row(
                            children: [
                              // Container(
                              //   width: 24.0,
                              //   height: 24.0,
                              //   child: IconButton(
                              //     icon: Icon((Platform.isIOS || Platform.isMacOS) ? Icons.arrow_back_ios : Icons.arrow_back),
                              //     onPressed: () => Navigator.of(context).pop(),
                              //     padding: EdgeInsets.zero,
                              //     iconSize: 24.0,
                              //   ),
                              // ),
                              IconButton(
                                icon: Icon((Platform.isIOS || Platform.isMacOS) ? Icons.arrow_back_ios : Icons.arrow_back),
                                onPressed: () => Navigator.of(context).pop(),
                                padding: EdgeInsets.zero,
                                iconSize: 24.0,
                              ),
                              Spacer(),
                              // IconButton(
                              //   icon: Icon(FontAwesomeIcons.discord),
                              //   onPressed: () => launch('https://discord.gg/5G8hpgHkXB'),
                              // ),
                              // IconButton(
                              //   icon: Icon(FontAwesomeIcons.twitter),
                              //   onPressed: () {},
                              // ),
                              IconButton(
                                icon: Icon(FontAwesomeIcons.github),
                                onPressed: () => launch('https://github.com/alexandr-io/alexandrio'),
                              ),
                              // IconButton(
                              //   icon: Icon(FontAwesomeIcons.patreon),
                              //   onPressed: () => launch('https://patreon.com/chatsen'),
                              // ),
                            ],
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Settings',
                              style: Theme.of(context).textTheme.headline4!.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  // pinned: true,
                  floating: true,
                  delegate: _SliverAppBarDelegate(
                    minHeight: 64.0 + MediaQuery.of(context).padding.top,
                    maxHeight: 64.0 + MediaQuery.of(context).padding.top,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0) + EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                      child: Material(
                        borderRadius: BorderRadius.circular(64.0),
                        color: Theme.of(context).colorScheme.surface,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Center(
                            child: Row(
                              children: [
                                Icon(Icons.search),
                                SizedBox(
                                  width: 12.0,
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: searchController,
                                    decoration: InputDecoration(
                                      hintText: 'Search settings',
                                      isDense: true,
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) => setState(() {}),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) => listChildren[index],
                    childCount: listChildren.length,
                  ),
                ),
              ],
            );
          },
        ),
      );
}


/*
                  // SliverAppBar(
                  //   pinned: false,
                  //   snap: false,
                  //   floating: true,
                  //   expandedHeight: 128.0 * 1.5,
                  //   // titleSpacing: 0.0,
                  //   // leading: Container(),
                  //   // leadingWidth: 0.0,
                  //   // automaticallyImplyLeading: false,
                  //   flexibleSpace: FlexibleSpaceBar(
                  //     title: Row(
                  //       children: [
                  //         Container(
                  //           width: 24.0,
                  //           height: 24.0,
                  //           child: IconButton(
                  //             icon: Icon(Icons.arrow_back),
                  //             onPressed: () => Navigator.of(context).pop(),
                  //             padding: EdgeInsets.zero,
                  //             iconSize: 24.0,
                  //           ),
                  //         ),
                  //         SizedBox(width: 8.0),
                  //         Text('Settings'),
                  //       ],
                  //     ),
                  //     titlePadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  //   ),
                  // ),
*/
