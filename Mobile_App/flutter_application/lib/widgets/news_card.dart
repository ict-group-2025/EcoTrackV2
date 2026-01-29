
import 'package:flutter/material.dart';
import '../models/data_models.dart';

class NewsCard extends StatelessWidget {
  final NewsArticle article;

  const NewsCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(
                  article.imageUrl ?? 'https://picsum.photos/200/200',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(article.category),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    article.category,
                    style: TextStyle(
                      fontSize: 10,
                      color: _getCategoryTextColor(article.category),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  article.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      article.readTime,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 8),
                    Text('•', style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(width: 8),
                    Text(
                      article.timeAgo,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.bookmark_border, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toUpperCase()) {
      case 'ENVIRONMENT':
        return Colors.blue[50]!;
      case 'HEALTH':
        return Colors.green[50]!;
      case 'GLOBAL NEWS':
        return Colors.orange[50]!;
      default:
        return Colors.grey[50]!;
    }
  }

  Color _getCategoryTextColor(String category) {
    switch (category.toUpperCase()) {
      case 'ENVIRONMENT':
        return Colors.blue[700]!;
      case 'HEALTH':
        return Colors.green[700]!;
      case 'GLOBAL NEWS':
        return Colors.orange[700]!;
      default:
        return Colors.grey[700]!;
    }
  }
}
