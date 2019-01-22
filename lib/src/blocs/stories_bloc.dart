import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';
import 'dart:async';

class StoriesBloc {
  // Repository passes the info to the StoriesBloc
  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>(); // similar to StreamController

  // Getters to streams
  Observable<List<int>> get topIds => _topIds.stream;

  // hide the sink, we don't want it publicly available
  // since the only thing that needs access to it is the repository
  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  // turn Future<ItemModel> into a Map of these emitted events
  _itemsTransformer() {
    return ScanStreamTransformer(
      // cache is this Map that is persisted
      (Map<int, Future<ItemModel>> cache, int id, _count) {
        
      },
      <int, Future<ItemModel>>{},
    );
  }

  dispose() {
    _topIds.close();
  }
}