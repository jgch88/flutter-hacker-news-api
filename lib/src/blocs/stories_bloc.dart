import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';

class StoriesBloc {
  final _topIds = PublishSubject<List<int>>(); // similar to StreamController

  // Getters to streams
  Observable<List<int>> get topIds => _topIds.stream;

  dispose() {
    _topIds.close();
  }
}