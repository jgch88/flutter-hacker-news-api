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
    
  }
}