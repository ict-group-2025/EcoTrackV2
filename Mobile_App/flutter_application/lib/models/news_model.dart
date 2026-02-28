class NewsArticle {
  final int id;
  final String title;
  final String summary;
  final String? content;
  final String imageUrl;
  final String link;
  final String category;
  final String source;
  final String? author;
  final String publishedAt;
  final String createdAt;
  final String guid;

  NewsArticle({
    required this.id,
    required this.title,
    required this.summary,
    this.content,
    required this.imageUrl,
    required this.link,
    required this.category,
    required this.source,
    this.author,
    required this.publishedAt,
    required this.createdAt,
    required this.guid,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      content: json['content'],
      imageUrl: json['imageUrl'] ?? '',
      link: json['link'] ?? '',
      category: json['category'] ?? '',
      source: json['source'] ?? '',
      author: json['author'],
      publishedAt: json['publishedAt'] ?? '',
      createdAt: json['createdAt'] ?? '',
      guid: json['guid'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'content': content,
      'imageUrl': imageUrl,
      'link': link,
      'category': category,
      'source': source,
      'author': author,
      'publishedAt': publishedAt,
      'createdAt': createdAt,
      'guid': guid,
    };
  }
}

class NewsResponse {
  final int size;
  final bool last;
  final int totalPages;
  final int page;
  final List<NewsArticle> content;
  final int totalElements;

  NewsResponse({
    required this.size,
    required this.last,
    required this.totalPages,
    required this.page,
    required this.content,
    required this.totalElements,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    final contentList = json['content'] as List<dynamic>? ?? [];
    final articles = contentList.map((item) => NewsArticle.fromJson(item)).toList();

    return NewsResponse(
      size: json['size'] ?? 0,
      last: json['last'] ?? false,
      totalPages: json['totalPages'] ?? 0,
      page: json['page'] ?? 0,
      content: articles,
      totalElements: json['totalElements'] ?? 0,
    );
  }
}
