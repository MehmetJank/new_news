import 'package:dio/dio.dart';

import '../screens/news_screen/components/news_model.dart';

class NewsApi {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://newsapi.org/v2/top-headlines?pageSize=10';
  final String _apiKey = "c38fecd54f2448c8b928906f3e93c5f8";
  List<NewsModel> news = [];

  Future<void> getNews(String country, String language, int page) async {
    String url;
    if (language == '') {
      url = '$_baseUrl&country=$country&page=$page&apiKey=$_apiKey';
    } else {
      url =
          '$_baseUrl&country=$country&language=$language&page=$page&apiKey=$_apiKey';
    }
    final response = await _dio.get(
      url,
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
        },
      );
    } else {
      throw Exception('News request failed');
    }
  }

  Future<void> getNewsByCategory(
      String country, String language, String category, int page) async {
    String url;
    if (language == '') {
      url =
          '$_baseUrl&country=$country&category=$category&page=$page&apiKey=$_apiKey';
    } else {
      url =
          '$_baseUrl&country=$country&category=$category&language=$language&page=$page&apiKey=$_apiKey';
    }
    print(url);
    final response = await _dio.get(
      url,
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
        },
      );
    } else {
      throw Exception('News request failed');
    }
  }
}
