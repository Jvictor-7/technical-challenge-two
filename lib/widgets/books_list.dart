import 'package:flutter/material.dart';
import 'package:desafio2/models/book.dart';
import 'dart:convert';

class BooksList extends StatelessWidget {
  final List<Book> books;
  final Function(Book) onBookTapped;
  final Function(Book) onBookStarred;

  const BooksList({
    super.key,
    required this.books,
    required this.onBookTapped,
    required this.onBookStarred,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (BuildContext context, int i) {
        final Book book = books[i];

        String decodedTitle = utf8.decode(book.title.runes.toList());
        String decodedAuthor = utf8.decode(book.author.runes.toList());

        return Card(
          elevation: 4.0,
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: InkWell(
            onTap: () {
              onBookTapped(book);
            },
            child: ListTile(
              title: Text(decodedTitle),
              subtitle: Text(decodedAuthor),
              leading: Image.network(book.cover_url),
              trailing: IconButton(
                onPressed: () {
                  onBookStarred(book);
                },
                icon: book.is_starred
                    ? const Icon(Icons.star, color: Colors.red)
                    : const Icon(Icons.star_border_outlined),
              ),
            ),
          ),
        );
      },
    );
  }
}
