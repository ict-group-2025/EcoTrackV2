import 'package:flutter/foundation.dart';
import '../models/news_model.dart';
import '../services/news_service.dart';

class NewsController extends ChangeNotifier {
  List<NewsArticle> _articles = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _currentPage = 0;
  int _totalPages = 0;
  int _totalElements = 0;
  String _currentCategory = 'health';

  // Getters
  List<NewsArticle> get articles => _articles;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalElements => _totalElements;
  String get currentCategory => _currentCategory;
  bool get hasMorePages => _currentPage < _totalPages - 1;

  // Load news for specific category
  Future<void> loadNews({
    String category = 'health',
    int page = 0,
    int size = 10,
    bool refresh = false,
  }) async {
    if (refresh) {
      _currentPage = 0;
      _articles.clear();
    }

    _setLoading(true);
    _errorMessage = null;

    try {
      final response = await NewsService.getNews(
        category: category,
        page: page,
        size: size,
      );

      print('NewsController loaded ${response.content.length} articles');

      if (refresh || page == 0) {
        _articles = response.content;
      } else {
        _articles.addAll(response.content);
      }

      _currentPage = response.page;
      _totalPages = response.totalPages;
      _totalElements = response.totalElements;
      _currentCategory = category;

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      print('NewsController error: $_errorMessage');
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Load more news (pagination)
  Future<void> loadMoreNews() async {
    if (!hasMorePages || _isLoading) return;

    await loadNews(
      category: _currentCategory,
      page: _currentPage + 1,
    );
  }

  // Refresh news
  Future<void> refreshNews() async {
    await loadNews(
      category: _currentCategory,
      page: 0,
      refresh: true,
    );
  }

  // Change category and load news
  Future<void> changeCategory(String category) async {
    if (_currentCategory == category) return;

    await loadNews(
      category: category,
      page: 0,
      refresh: true,
    );
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Get article by ID
  NewsArticle? getArticleById(int id) {
    try {
      return _articles.firstWhere((article) => article.id == id);
    } catch (e) {
      return null;
    }
  }
}
