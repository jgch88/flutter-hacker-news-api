import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';
import 'dart:async';

class StoriesBloc {
  // Repository passes the info to the StoriesBloc
  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>(); // similar to StreamController
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>(); // this sink must be exposed outside, other screens need item info
  final _itemsFetcher = PublishSubject<int>();

  // Getters to streams
  Observable<List<int>> get topIds => _topIds.stream;
  Observable<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream;

  // Getters to sinks
  Function(int) get fetchItem => _itemsFetcher.sink.add;

  StoriesBloc() {
    _itemsFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
  }

  // hide the sink, we don't want it publicly available
  // since the only thing that needs access to it is the repository
  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  clearCache() {
    return _repository.clearCache();
  }

  // turn Future<ItemModel> into a Map of these emitted events
  _itemsTransformer() {
    return ScanStreamTransformer(
      // cache is this Map that is persisted
      (Map<int, Future<ItemModel>> cache, int id, _count) {
        cache[id] = _repository.fetchItem(id);
        print(_count);
        return cache; // cache is like an accumulator, maybe this is a reducer
      },
      <int, Future<ItemModel>>{},
    );
  }

  dispose() {
    _topIds.close();
    _itemsFetcher.close();
    _itemsOutput.close();
  }
}