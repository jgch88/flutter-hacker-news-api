import 'package:flutter/material.dart';
import '../blocs/stories_provider.dart';
import '../widgets/news_list_tile.dart';
import '../widgets/refresh.dart';

class NewsList extends StatelessWidget {
  Widget build(context) {
    final bloc = StoriesProvider.of(context);
    // crawls up to tree to get reference
    // to the bloc

    return Scaffold(
      appBar: AppBar(
        title: Text('Top News'),
      ),
      body: buildList(bloc),
    );
  }

  /*
  StreamBuilder only needs to consume from a stream.
  It doesn't care about the sink. The StoriesSink was kickstarted
  in App.Routes() via storiesBloc.fetchTopIds().

  The topIds stream is exposed by storiesBloc for the StreamBuilder to
  consume.
  */
  Widget buildList(StoriesBloc bloc) {
    return StreamBuilder(
      stream: bloc.topIds,
      builder: (context, AsyncSnapshot<List<int>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Refresh(
          child: ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, int index) {
              bloc.fetchItem(snapshot.data[index]);

              return NewsListTile(itemId: snapshot.data[index]);
            },
          ),
        );

      },
    );
  }
}