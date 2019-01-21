import 'package:http/http.dart' show Client;
// had to manually add this to pubspec.yaml and flutter packages get

class NewsApiProvider {
  Client client = Client();

  fetchTopIds() {
    client.get('https://hacker-news.firebaseio.com/v0/topstories.json');
  }

  fetchItem() {

  }
}