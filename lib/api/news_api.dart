import 'package:dio/dio.dart';

import '../screens/news_screen/components/news_model.dart';

class NewsApi {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://newsapi.org/v2/top-headlines?pageSize=10';
  final String _apiKey = "";
  List<NewsModel> news = [];

  Future<void> getNews(
    String country,
    String language,
    int page,
  ) async {
    final response = await _dio.get(
      '$_baseUrl&country=$country&language=$language&page=$page&apiKey=$_apiKey',
      options: Options(
        receiveTimeout: const Duration(
          seconds: 10,
        ),
        sendTimeout: const Duration(
          seconds: 10,
        ),
      ),
    );
    final data = response.data;

    if (data["status"] == "ok") {
      data["articles"].forEach(
        (element) {
          if (element["urlToImage"] != null && element["description"] != null) {
            NewsModel newsModel = NewsModel(
              title: element["title"] ?? "Unknown",
              author: element["author"] ?? "Unknown",
              description: element["description"] ?? "Unknown",
              urlToImage: element["urlToImage"] ?? "Unknown",
              publishedAt: DateTime.parse(element["publishedAt"] ?? "Unknown"),
              content: element["content"] ?? "Unknown",
              articleUrl: element["url"] ?? "Unknown",
            );
            news.add(newsModel);
          }
        },
      );
    } else {
      throw Exception('News request failed');
    }
  }

  Future<void> getNewsByCategory(
    String country,
    String language,
    String category,
    int page,
  ) async {
    final response = await _dio.get(
      '$_baseUrl/country=$country&category=$category&language=$language&page=$page&apiKey=$_apiKey',
      options: Options(
        receiveTimeout: const Duration(
          seconds: 10,
        ),
        sendTimeout: const Duration(
          seconds: 10,
        ),
      ),
    );
    final data = response.data;

    if (data["status"] == "ok") {
      data["articles"].forEach(
        (element) {
          if (element["urlToImage"] != null && element["description"] != null) {
            NewsModel newsModel = NewsModel(
              title: element["title"] ?? "Unknown",
              author: element["author"] ?? "Unknown",
              description: element["description"] ?? "Unknown",
              urlToImage: element["urlToImage"] ?? "Unknown",
              publishedAt: DateTime.parse(element["publishedAt"] ?? "Unknown"),
              content: element["content"] ?? "Unknown",
              articleUrl: element["url"] ?? "Unknown",
            );
            news.add(newsModel);
          }
        },
      );
    } else {
      throw Exception('News request failed');
    }
  }
}
