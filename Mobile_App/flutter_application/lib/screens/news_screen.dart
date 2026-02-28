import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/news_controller.dart';
import '../models/news_model.dart';
import '../utils/news_article_card.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = ['weather', 'health', 'air'];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    
    // Load initial news
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsController>().loadNews(category: 'health');
    });
    
    // Listen to tab changes
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final category = _categories[_tabController.index];
        context.read<NewsController>().changeCategory(category);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FA),
        elevation: 0,
        title: const Text(
          'News',
          style: TextStyle(
            color: Color(0xFF1A2340),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: const Color(0xFF2196F3),
          unselectedLabelColor: const Color(0xFF8A94A6),
          indicatorColor: const Color(0xFF2196F3),
          indicatorWeight: 3,
          tabs: _categories.map((category) {
            return Tab(
              text: _getCategoryDisplayName(category),
            );
          }).toList(),
        ),
      ),
      body: Consumer<NewsController>(
        builder: (context, newsController, child) {
          if (newsController.isLoading && newsController.articles.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (newsController.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Lỗi tải tin tức',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.red[400],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    newsController.errorMessage!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8A94A6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      newsController.clearError();
                      newsController.refreshNews();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          if (newsController.articles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.article_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Không có tin tức nào',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8A94A6),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await newsController.refreshNews();
            },
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (scrollInfo is ScrollEndNotification &&
                    scrollInfo.metrics.extentAfter < 200 &&
                    newsController.hasMorePages) {
                  newsController.loadMoreNews();
                }
                return false;
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: newsController.articles.length + (newsController.hasMorePages ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == newsController.articles.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final article = newsController.articles[index];
                  return NewsArticleCard(article: article);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  String _getCategoryDisplayName(String category) {
    switch (category) {
      case 'weather':
        return 'Weather';
      case 'health':
        return 'Health';
      case 'air':
        return 'Air Quality';
      default:
        return category;
    }
  }
}

