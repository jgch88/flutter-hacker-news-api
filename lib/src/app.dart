import 'package:flutter/material.dart';
import 'screens/news_list.dart';
import 'blocs/stories_provider.dart';
import 'screens/news_detail.dart';
import 'blocs/comments_provider.dart';

class App extends StatelessWidget {
  Widget build(context) {

    return CommentsProvider(
      child:StoriesProvider(
        child: MaterialApp(
          title: 'News!',
          onGenerateRoute: routes,
        ),
      ),
    );
  }

  Route routes(RouteSettings settings) {
    // passed from Navigator.pushNamed
    if (settings.name == '/') {
      return MaterialPageRoute(
        builder: (context) {
          return NewsList();
        },
      );
    } else {
      return MaterialPageRoute(
        builder: (context) {
          // extract item id from settings.name
          // pass into NewsDetail
          // good place to do some initialization // data fetching
          final itemId = int.parse(settings.name.replaceFirst('/', ''));

          final commentsBloc = CommentsProvider.of(context);
          commentsBloc.fetchItemWithComments(itemId);

          return NewsDetail(
            itemId: itemId,
          );
        }
      );
    }
  }
}