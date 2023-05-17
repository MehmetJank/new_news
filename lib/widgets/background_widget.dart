import 'package:flutter/material.dart';
import 'dart:ui';

class CustomBackground extends StatelessWidget {
  const CustomBackground({
    super.key,
    required this.assetImage,
  });

  final String assetImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(assetImage),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
          ),
        ),
      ),
    );
  }
}
