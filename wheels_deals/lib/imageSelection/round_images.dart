import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppRoundImage extends StatelessWidget {
  final ImageProvider provider;
  final double height;
  final double width;

  AppRoundImage(NetworkImage networkImage,
      {this.provider, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: Image(
        image: provider,
        height: height,
        width: width,
      ),
    );
  }

  factory AppRoundImage.url(String url, {double height, double width}) {
    return AppRoundImage(
      NetworkImage(url),
      height: height,
      width: width,
    );
  }
}
