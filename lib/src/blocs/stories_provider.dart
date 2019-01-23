import 'package:flutter/material.dart';
import 'stories_bloc.dart';
export 'stories_bloc.dart'; // so that we don't have to keep importing both provider and bloc

// InheritedWidget allows us to reach up the context tree
// and get an instance of the StoriesProvider
// so that it can get access to the Stories BLOC

// InheritedWidget allows us to reach up the context tree
// and get an instance of the StoriesProvider
// so that it can get access to the Stories BLOC

// Edited Notes (2019/01/23):
//
// Readings:
// https://docs.flutter.io/flutter/widgets/BuildContext/inheritFromWidgetOfExactType.html
// https://docs.flutter.io/flutter/widgets/InheritedWidget-class.html
// https://www.dartlang.org/guides/language/language-tour#constructors
//
// context has a method called inheritFromWidgetOfExactType (see docs)
// that allows the child widget to reach up the context tree and find a target type
// that is a concrete InheritedWidget subclass (e.g. StoriesProvider).
// It returns the InheritedWidget reference, but we must still cast it using the
// "as" keyword to access the concrete subclass' fields.
//
// This allows our of(context) method to return the field (i.e. state) we are interested
// in, from any child Widget, without having to do any parent/child
// react style props passing.
//
// Note: The of(context) method should be called only in build(context) methods
// of child widgets
// Note: This of(context) method is static, so doesn't require instantiation
// when imported by child widgets
//
// Note: The Providers are Singletons and are instantiated only once, and they
// are at the root of the app, encapsulating even MaterialApp(). This ensures
// that the Providers are the single sources of truth within the app.
//
// How does the constructor of the Provider work?
// It instantiates a Singleton bloc and stores a reference on its field.
// Calls a superclass constructor. Need to use this to pass its wrapped
// child Widget's constructor info to the InheritedWidget superclass's constructor.

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