import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_news/screens/news_screen/components/categories.dart';
import 'package:new_news/screens/news_screen/components/news_tile.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: const Column(
        children: [
          NewsCategoryRow(),
          NewsTile(
              imgUrl:
                  "https://cdn.pixabay.com/photo/2023/05/04/02/24/bali-7969001_960_720.jpg",
              desc: "This is a description",
              title: "This is a title",
              content: "This is a content",
              posturl: "This is a posturl")
        ],
      ),
    );
  }
}
