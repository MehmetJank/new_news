import 'package:flutter/material.dart';

class NewsCategoryRow extends StatefulWidget {
  const NewsCategoryRow({Key? key}) : super(key: key);

  @override
  State<NewsCategoryRow> createState() => _NewsCategoryRowState();
}

class _NewsCategoryRowState extends State<NewsCategoryRow> {
  List<String> categories = [
    'Politics',
    'Sports',
    'Entertainment',
    'Technology',
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(categories.length, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                // color: selectedIndex == index ? Colors.blue : null,
                color: selectedIndex == index
                    ? Theme.of(context).primaryColor
                    : null,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  color: selectedIndex == index ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
