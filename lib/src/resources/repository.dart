import '../models/item_model.dart';
import 'news_api_provider.dart';
import 'news_db_provider.dart';
import 'dart:async';

// governs access to our providers
class Repository {
  NewsDbProvider dbProvider = NewsDbProvider();
  NewsApiProvider apiProvider = NewsApiProvider();
  // remember to init() dbProvider! constructor not sufficient

  Future<List<int>> fetchTopIds() {
    return apiProvider.fetchTopIds(); // not caching top ids, just one network call
  }

  Future<ItemModel> fetchItem(int id) async {
    // check dbProvider first
    var item = await dbProvider.fetchItem(id);
    if (item != null) {
      return item;
    }

    // didn't find it in db, use apiProvider
    item = await apiProvider.fetchItem(id);
    // store it for future use
    dbProvider.addItem(item);

    return item;
  }

}

// decouple the Class implementations from their responsibilities
abstract class Source {
  Future<List<int>> fetchTopIds();
  Future<ItemModel> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
}