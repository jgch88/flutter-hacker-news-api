import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'; // work with underlying file system
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import '../models/item_model.dart';
import 'repository.dart';

class NewsDbProvider implements Source, Cache {
  Database db; // link to sqflite database

  // because we cannot call init on the instance outside,
  // we place it in the constructor
  NewsDbProvider() {
    init();
  }

  Future<List<int>> fetchTopIds() {
    // not implemented - cache will need to know when to refresh its cache
    return null;
  }

  // can't use this logic in constructors because you can't do async code
  // in constructors
  void init() async {
    // returns a directory where you can safely store stuff permanently
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // actual path
    final path = join(documentsDirectory.path, "items1.db");

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

  Future<ItemModel> fetchItem(int id) async {
    // maps has a type Map<String, dynamic>
    final maps = await db.query(
      "Items", // Table name
      columns: null, // can specify columns, or do null (like select *)
      where: "id = ?",
      whereArgs: [id], // prevents SQL injection, via sanitisation
    );

    if (maps.length > 0) {
      // need to convert map into a ItemModel, but it is not the same as JSON
      return ItemModel.fromDb(maps.first); // fetching only one item!
    }

    return null;
  }

  // getting an error when we take it out the db and immediately try to add it back
  // see repository's fetchItem(). requires app reload to see it throw error
  Future<int> addItem(ItemModel item) { // don't need to mark async
    return db.insert(
        "Items",
        item.toDbMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
    ); // not waiting for db result/error
  }
}

final newsDbProvider = NewsDbProvider();