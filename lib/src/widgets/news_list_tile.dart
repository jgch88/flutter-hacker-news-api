import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../blocs/stories_provider.dart';
import 'dart:async';

class NewsListTile extends StatelessWidget {
  final int itemId; // passed in by parent

  NewsListTile({this.itemId});

  Widget build(context) {
    final bloc = StoriesProvider.of(context);

    return StreamBuilder(
      stream: bloc.items,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot){
        if (!snapshot.hasData){
          return Text('Stream still loading');
        }

        return FutureBuilder(
          future: snapshot.data[itemId],
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return Text('Still loading item $itemId');
            }

            return buildTile(itemSnapshot.data);
          }
        );
      }
    );
  }

  Widget buildTile(ItemModel item) {
    return ListTile(
      title: Text(item.title),
      subtitle: Text('${item.score} votes'),
      trailing: Column(
        children: [
          Icon(Icons.comment),
          Text('${item.descendants}'),
        ]
      )

    );
  }
}