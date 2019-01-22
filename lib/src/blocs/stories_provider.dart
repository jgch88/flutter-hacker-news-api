import 'package:flutter/material.dart';
import 'stories_bloc.dart';
export 'stories_bloc.dart'; // so that we don't have to keep importing both provider and bloc

// InheritedWidget allows us to reach up the context tree
// and get an instance of the StoriesProvider
// so that it can get access to the Stories BLOC
class StoriesProvider extends InheritedWidget {
  final StoriesBloc bloc;

  StoriesProvider({Key key, Widget child})
    : bloc = StoriesBloc(),
      super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static StoriesBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(StoriesProvider)
            as StoriesProvider)
            .bloc;
  }
}