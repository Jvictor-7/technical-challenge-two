// ignore_for_file: non_constant_identifier_names

class Book {
  int id;
  String title;
  String author;
  String cover_url;
  String download_url;
  bool is_starred;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.cover_url,
    required this.download_url,
    required this.is_starred,
  });
}
