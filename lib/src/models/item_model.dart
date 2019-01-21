// represents an Item we've loaded into our App
// e.g. a HackerNews story or a comment

class ItemModel {
  final int id;
  final bool deleted;
  final String type;
  final String by;
  final int time; //Unix time
  final String text;
  final bool dead;
  final int parent;
  final List<dynamic> kids;
  final String url;
  final int score;
  final String title;
  final int descendants;
}