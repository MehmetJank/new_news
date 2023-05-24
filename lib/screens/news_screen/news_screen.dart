import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../api/news_api.dart';
import '../../storage/storage.dart';
import 'components/categoires_2.dart';
import 'components/category_model.dart';
import 'components/news_tile.dart';

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
  List<CategorieModel> categories = [];

  @override
  void initState() {
    super.initState();
    categories = getCategories();
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

  Future<List<dynamic>> getNewsSettings() async {
    AppStorage storage = AppStorage();
    var data = await storage.readAll();
    String language = data["language"];
    String country;

    if (language == "en") {
      country = "us";
    } else if (language == "tr") {
      country = "tr";
      language = "";
    } else if (language == "fr") {
      country = "fr";
    } else {
      country = "us";
    }

    return [language, country];
  }

  Future<void> getNews() async {
    List newsSettings = await getNewsSettings();
    NewsApi newsApi = NewsApi();
    await newsApi.getNews(newsSettings[1], newsSettings[0], currentPage);
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
          title: Image.asset(
            "assets/images/logo.png",
            height: 55,
            fit: BoxFit.cover,
            color: Colors.white,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // GoRouter.of(context).go('/settings');
                GoRouter.of(context).push('/settings');
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
                    Container(
                      padding: const EdgeInsets.all(6),
                      height: 70,
                      child: ListView.builder(
                        itemCount: categories.length,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return CategoriesCard(
                            categoryImage: categories[index].imagePath,
                            categoryName: categories[index].categorieName,
                          );
                        },
                      ),
                    ),
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
