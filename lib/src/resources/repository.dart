import '../models/item_model.dart';
import 'news_api_provider.dart';
import 'news_db_provider.dart';
import 'dart:async';

class Repository {
  NewsDbProvider dbProvider = NewsDbProvider();
  NewsApiProvider apiProvider = NewsApiProvider();
  // remember to init() dbProvider! constructor not sufficient

  fetchTopIds() {

  }

  fetchItem() {
    
  }

}