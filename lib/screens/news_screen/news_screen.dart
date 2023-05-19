import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_news/screens/news_screen/components/categories.dart';
import 'package:new_news/screens/news_screen/components/news_tile.dart';

import '../../api/news_api.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  bool _isLoading = true;
  List<dynamic> newsList = [];
  int currentPage = 1;
  bool isFetching = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getNews();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchMoreNews();
      }
    });
  }

  @override
  void dispose() {
    // ScrollController'ı temizleme
    _scrollController.dispose();
    super.dispose();
  }

  void getNews() async {
    NewsApi newsApi = NewsApi();
    await newsApi.getNews("tr", "tr", currentPage);
    await Future.delayed(const Duration(seconds: 1));
    newsList.addAll(newsApi.news);
    setState(() {
      _isLoading = false;
    });
  }

  void fetchMoreNews() async {
    if (!isFetching) {
      setState(() {
        isFetching = true;
      });
      currentPage++;

      getNews();

      setState(() {
        isFetching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("News"),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                context.go('/settings');
              },
            ),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: <Widget>[
                    const NewsCategoryRow(),
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: ListView.builder(
                          itemCount: newsList.length + 1,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (index == newsList.length) {
                              return _buildLoader();
                            } else {
                              return NewsTile(
                                imgUrl: newsList[index].urlToImage ?? "",
                                title: newsList[index].title ?? "",
                                desc: newsList[index].description ?? "",
                                content: newsList[index].content ?? "",
                                posturl: newsList[index].articleUrl ?? "",
                              );
                            }
                          }),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildLoader() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16.0),
      child: const CircularProgressIndicator(),
    );
  }
}
