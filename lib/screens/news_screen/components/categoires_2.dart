import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../localizations/localizations.dart';

class CategoriesCard extends StatefulWidget {
  final String categoryImage, categoryName;

  const CategoriesCard(
      {super.key, required this.categoryImage, required this.categoryName});

  @override
  State<CategoriesCard> createState() => _CategoriesCardState();
}

class _CategoriesCardState extends State<CategoriesCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //get english name of category
        String categoryNameLower = widget.categoryName.toLowerCase();
        GoRouter.of(context).push('/news/$categoryNameLower');
      },
      child: Container(
        margin: EdgeInsets.only(right: 14),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(
                widget.categoryImage,
                height: 60,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 60,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black26),
              child: Text(
                getTranslatedText(context, widget.categoryName.toLowerCase()),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }
}
