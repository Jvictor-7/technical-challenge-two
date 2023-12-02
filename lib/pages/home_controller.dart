// ignore_for_file: avoid_print
import 'dart:convert';

import '../models/book.dart';
import 'package:http/http.dart' as http;

class HomeController {
  List<Book> table = [];

  Future<void> updateTable() async {
    var response = await http.get(
      Uri.parse('https://escribo.com/books.json'),
    );

    if (response.statusCode == 200) {
      // print(response.body);
      final List<dynamic> jsonList = jsonDecode(response.body);

      List<Book> books = jsonList.map((json) {
        return Book(
          id: json['id'],
          title: json['title'],
          author: json['author'],
          cover_url: json['cover_url'],
          download_url: json['download_url'],
          is_starred: false,
        );
      }).toList();

      table = books;
    } else {
      throw Exception('Falha de Comunicação com a API');
    }
  }

  List<Book> getFavorites() {
    return table.where((book) => book.is_starred).toList();
  }
}
