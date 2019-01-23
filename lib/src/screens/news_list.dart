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
  Here, the StreamBuilder only needs to consume from a stream (RxDart's PublishSubject).
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

        /*
        Refresh is actually using the RefreshIndicator, and
        implements the bloc refresh logic within onRefresh().
         */
        return Refresh(
          child: ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, int index) {
              /*
              Here the individual item stream (RxDart's PublishSubject)
              exposes both the sink and stream.

              We're using the individual item sink here to pass it itemId events.

              The individual item's stream is consumed not here, but
              in NewsListTile's StreamBuilder.
              */
              bloc.fetchItem(snapshot.data[index]);

              return NewsListTile(itemId: snapshot.data[index]);
            },
          ),
        );

      },
    );
  }
}