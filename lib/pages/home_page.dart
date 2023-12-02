import 'package:flutter/material.dart';
import 'package:desafio2/controllers/home_controller.dart';
import 'package:desafio2/models/book.dart';
import 'package:desafio2/widgets/books_list.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Book> booksList = [];
  late List<Book> favoritesList = [];
  final HomeController controller = HomeController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    updateBooks();
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

  void unfavoriteBook(Book book) {
    if (!book.is_starred) {
      setState(() {
        favoritesList.remove(book);
      });
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
          BooksList(
            books: booksList,
            onBookTapped: (book) {
              Uri bookDownload = Uri.parse(book.download_url);
              _launchUrl(bookDownload);
            },
            onBookStarred: (book) {
              setState(() {
                book.is_starred = !book.is_starred;
              });
            },
          ),
          BooksList(
            books: favoritesList,
            onBookTapped: (book) {
              Uri bookDownload = Uri.parse(book.download_url);
              _launchUrl(bookDownload);
            },
            onBookStarred: (book) {
              setState(() {
                book.is_starred = !book.is_starred;
                unfavoriteBook(book);
              });
            },
          ),
        ],
      ),
    );
  }
}
