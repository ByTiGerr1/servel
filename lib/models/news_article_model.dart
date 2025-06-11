class NewsArticle {
  final String title;
  final String? description;
  final String url;
  final String? imageUrl;
  final DateTime publishedAt;

  NewsArticle({
    required this.title,
    this.description,
    required this.url,
    this.imageUrl,
    required this.publishedAt,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      description: json['text'] ?? json['description'],
      url: json['url'] ?? '',
      imageUrl: json['image'],
      publishedAt: DateTime.parse(json['publish_date']),
    );
  }
}