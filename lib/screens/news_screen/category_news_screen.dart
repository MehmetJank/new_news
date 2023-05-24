import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_news/screens/news_screen/components/news_tile.dart';

import '../../api/news_api.dart';

class CategoryNews extends StatefulWidget {
  final String newsCategory;
  const CategoryNews({super.key, required this.newsCategory});

  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = true;
  List<dynamic> newsList = [];
  int currentPage = 1;
  bool isFetching = false;

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
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> getNews() async {
    NewsApi newsApi = NewsApi();
    await newsApi.getNewsByCategory(
        "us", "en", widget.newsCategory, currentPage);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        newsList.addAll(newsApi.news);
        _isLoading = false;
      });
    }
  }

  void fetchMoreNews() {
    if (!isFetching) {
      setState(() {
        isFetching = true;
        currentPage++;
      });

      getNews().then((_) {
        setState(() {
          isFetching = false;
        });
      }).catchError((error) {
        setState(() {
          isFetching = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.newsCategory.toUpperCase()),
          centerTitle: true,
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: <Widget>[
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
                                imgUrl: newsList[index].urlToImage ??
                                    "https://www.rollingstone.com/wp-content/uploads/2022/07/BCS_600_GL_0325_0151-RT-1C.jpg?w=1581&h=1054&crop=1",
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
