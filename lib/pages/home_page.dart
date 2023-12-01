// ignore_for_file: avoid_print, unused_field, prefer_typing_uninitialized_variables, deprecated_member_use

import 'dart:async';
import 'package:desafio2/models/book.dart';
import 'package:desafio2/pages/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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
          favoritesList = controller.getFavoritos();
        });
      }
    }
  }

  Future<void> updateBooks() async {
    await controller.updateTabela();
    setState(() {
      booksList = controller.tabela;
    });
  }

  Future<void> downloadFile(String url, String fileName) async {
    var request = await http.get(Uri.parse(url));
    var bytes = request.bodyBytes;

    var path = await _localPath;
    File file = File('$path/$fileName');
    await file.writeAsBytes(bytes);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
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
        final tabela = books;

        return Card(
          elevation: 4.0,
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: InkWell(
            onTap: () async {},
            child: ListTile(
              title: Text(tabela[i].title),
              subtitle: Text(tabela[i].author),
              leading: Image.network(tabela[i].cover_url),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    tabela[i].is_starred = !tabela[i].is_starred;
                  });
                },
                icon: tabela[i].is_starred
                    ? const Icon(Icons.star, color: Colors.red)
                    : const Icon(Icons.star_border_outlined),
              ),
              onTap: () async {
                try {
                  String downloadUrl = tabela[i].download_url;
                  String fileName =
                      '${tabela[i].title}.epub'; // Nome do arquivo a ser salvo

                  await downloadFile(downloadUrl, fileName);
                  // Aqui você pode exibir uma mensagem de sucesso ou realizar outra ação após o download
                } catch (e) {
                  // Trate erros durante o download
                  print('Erro durante o download: $e');
                }
              },
            ),
          ),
        );
      },
    );
  }
}
