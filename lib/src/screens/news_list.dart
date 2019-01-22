import 'package:flutter/material.dart';
import '../blocs/stories_provider.dart';

class NewsList extends StatelessWidget {
  Widget build(context) {
    final bloc = StoriesProvider.of(context);
    // crawls up to tree to get reference
    // to the bloc

    return Scaffold(
      appBar: AppBar(
        title: Text('Top News'),
      ),
      body: Text('Show List'),
    );
  }
}