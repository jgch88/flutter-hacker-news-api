import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'; // work with underlying file system
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import '../models/item_model.dart';

class NewsDbProvider {
  Database db; // link to sqflite database

  // can't use this logic in constructors because you can't do async code
  // in constructors
  init() async {
    // returns a directory where you can safely store stuff permanently
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // actual path
    final path = join(documentsDirectory.path, "items.db");

    // if user is opening the app for the first time, they do not have a db
    // openDatabase tries to find an existing db OR create a new db
    db = await openDatabase(
      path,
      version: 1, // schema versions for migrations
      onCreate: (Database newDb, int version) { // only called if db is being created
        newDb.execute("""
          CREATE TABLE Items
            (
              id INTEGER PRIMARY KEY,
              type TEXT,
              by TEXT,
              time INTEGER,
              text TEXT,
              parent INTEGER,
              kids BLOB,
              dead INTEGER,
              deleted INTEGER,
              url TEXT,
              score INTEGER,
              title TEXT,
              descendants INTEGER
            )
        """); // arbitrary line of sql to be executed
      },
    );
  }
}