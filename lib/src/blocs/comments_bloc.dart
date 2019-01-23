import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';

class CommentsBloc {
  final _repository = Repository();
  final _commentsFetcher = PublishSubject<int>();
  // Why BehaviorSubject and not another PublishSubject?
  //
  // https://tech.instacart.com/how-to-think-about-subjects-in-rxjava-part-1-ca509b981020
  // https://pub.dartlang.org/documentation/rxdart/latest/rx/PublishSubject-class.html
  // https://pub.dartlang.org/documentation/rxdart/latest/rx/BehaviorSubject-class.html
  // PublishSubject: sends only subsequent events after a subscriber connects
  // BehaviorSubject: sends the last recorded event and subsequent events after
  // a subscriber connects.

  // We're using this in conjunction with the transformer's accumulator
  // function -> so that any new subscribers to _commentOutput.stream
  // will get the full Map of the ints/itemModels that were previously processed
  // without having to restart the recursive process if they 'missed' it.

  // Type of output stream is Map<int, Future<ItemModel>>
  final _commentsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();

  // Streams
  Observable<Map<int, Future<ItemModel>>> get itemWithComments =>
    _commentsOutput.stream;

  // Sink
  Function(int) get fetchItemWithComments =>
    _commentsFetcher.sink.add;

  CommentsBloc() {
    _commentsFetcher.stream
        .transform(_commentsTransformer())
        .pipe(_commentsOutput);
  }

  // https://pub.dartlang.org/documentation/rxdart/latest/rx/ScanStreamTransformer-class.html
  // Applies an accumulator function over an observable sequence and
  // returns each intermediate result. You can pass in an optional initial
  // accumulator seed value.
  _commentsTransformer() {
    // converting an int into a Map<int, Future<ItemModel>>, for piping into the
    // BehaviorSubject _commentsOutput's sink
    return ScanStreamTransformer<int, Map<int, Future<ItemModel>>>(
      // accumulator function
      // first argument is the "accumulated" cache. starts off as the seed's empty
      // <int, Future<ItemModel>>{}
      // second argument is the item coming into the stream through the sink
      // third argument is the number of times (count) this ScanStreamTransformer
      // has been invoked
      (Map<int, Future<ItemModel>> cache, int id, countIndex) {
        cache[id] = _repository.fetchItem(id);
        cache[id].then((ItemModel item) {
          item.kids.forEach((kidId) =>
            fetchItemWithComments(kidId)
          );
        });
        return cache;
      },
        // Seed
      <int, Future<ItemModel>>{}
    );
  }


  dispose() {
    _commentsFetcher.close();
    _commentsOutput.close();
  }
}