import 'package:flutter/material.dart';
import '../blocs/stories_provider.dart';

// This class allows the user to "pull down to refresh" the list
// since db is permanently cached and doesn't update
class Refresh extends StatelessWidget {
  final Widget child;

  Refresh({this.child});

  Widget build(context) {
    final bloc = StoriesProvider.of(context);

    return RefreshIndicator(
      child: child,
      onRefresh: () async {
        await bloc.clearCache();
        await bloc.fetchTopIds();
      },
    );
  }
}