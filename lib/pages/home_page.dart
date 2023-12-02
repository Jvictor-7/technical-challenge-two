// ignore_for_file: avoid_print, unused_field, prefer_typing_uninitialized_variables, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'package:desafio2/models/book.dart';
import 'package:desafio2/pages/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  var controller;
  late TabController _tabController;
  late List<Book> booksList = [];
  late List<Book> favoritesList = [];

  @override
  void initState() {
    super.initState();
    controller = HomeController();
    _tabController = TabController(length: 2, vsync: this);
    updateBooks();
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (!_tabController.indexIsChanging) {
      if (_tabController.index == 1) {
        setState(() {
          favoritesList = controller.getFavorites();
        });
      }
    }
  }

  Future<void> updateBooks() async {
    await controller.updateTable();
    setState(() {
      booksList = controller.table;
    });
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Desafio 2 - Leitor de eBooks'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Livros'),
            Tab(text: 'Favoritos'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildBooksList(booksList),
          buildBooksList(favoritesList),
        ],
      ),
    );
  }

  Widget buildBooksList(List<Book> books) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (BuildContext context, int i) {
        final table = books;

        String decodedTitle = utf8.decode(table[i].title.runes.toList());
        String decodedAuthor = utf8.decode(table[i].author.runes.toList());

        return Card(
          elevation: 4.0,
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: InkWell(
            onTap: () async {},
            child: ListTile(
              title: Text(decodedTitle),
              subtitle: Text(decodedAuthor),
              leading: Image.network(table[i].cover_url),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    table[i].is_starred = !table[i].is_starred;
                  });
                },
                icon: table[i].is_starred
                    ? const Icon(Icons.star, color: Colors.red)
                    : const Icon(Icons.star_border_outlined),
              ),
              onTap: () async {
                Uri bookDownload = Uri.parse(table[i].download_url);
                _launchUrl(bookDownload);
              },
            ),
          ),
        );
      },
    );
  }
}
