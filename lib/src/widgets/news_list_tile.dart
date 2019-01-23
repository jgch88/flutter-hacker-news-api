import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../blocs/stories_provider.dart';
import 'dart:async';
import 'loading_container.dart';

class NewsListTile extends StatelessWidget {
  final int itemId; // passed in by parent

  NewsListTile({this.itemId});

  Widget build(context) {
    final bloc = StoriesProvider.of(context);

    return StreamBuilder(
      stream: bloc.items,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot){
        if (!snapshot.hasData){
          return LoadingContainer();
        }

        // this is an individual tile, so render an individual Future's
        // snapshot accordingly. but notice we're still accessing
        // the storiesBloc's items snapshot

        // within each item (snapshot.data[itemId]) is a future, which also has a
        // snapshot depending on its state

        // https://docs.flutter.io/flutter/widgets/AsyncSnapshot-class.html
        // We get AsyncSnapshots for free when using StreamBuilders/FutureBuilders,
        // this helps us code the conditional widget building based on
        // stream/future snapshots, without having to worry about
        // the mechanism of these async programming concepts.
        return FutureBuilder(
          future: snapshot.data[itemId],
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return LoadingContainer();
            }

            return buildTile(context, itemSnapshot.data);
          }
        );
      }
    );
  }

  Widget buildTile(BuildContext context, ItemModel item) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            print('${item.id} was tapped');
            Navigator.pushNamed(context, '/${item.id}');
            // passed to onGenerateRoute's settings
          },
          title: Text(item.title),
          subtitle: Text('${item.score} votes'),
          trailing: Column(
              children: [
                Icon(Icons.comment),
                Text('${item.descendants}'),
              ]
          ),
        ),
        Divider(
          height: 8.0,
        ),
      ]
    );
  }
}