import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:servel/config/app_config.dart';
import 'package:servel/models/news_article_model.dart';

class WorldNewsApiService {
  final String _baseUrl = AppConfig.worldNewsApiBaseUrl;
  final String _apiKey = AppConfig.worldNewsApiKey;

  Future<List<NewsArticle>> fetchTopHeadlines() async {
    final url = Uri.parse(
        '$_baseUrl/search-news?text=chile%20politica&language=es&source-countries=cl&api-key=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final List<dynamic> articlesJson = data['news'] as List<dynamic>? ?? [];
      return articlesJson
          .map((json) => NewsArticle.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch news: ${response.statusCode}');
    }
  }
}