import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wheels_deals/imageSelection/car_image.dart';

import '../imageSelection/user_image.dart';

class sellImages extends StatefulWidget {
  final List imageList;

  sellImages({this.imageList});

  @override
  State<sellImages> createState() => _sellImagesState();
}

class _sellImagesState extends State<sellImages> {
  File image1, image2, image3, nullimage;
  String url = "";
  int selectedPage = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        child: Stack(
          children: [
            PageView(
              onPageChanged: ((value) {
                setState(() {
                  selectedPage = value;
                });
              }),
              children: [
                for (var i = 0; i < widget.imageList.length; i++) Container()
              ],
            ),
            Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < widget.imageList.length; i++)
                      AnimatedContainer(
                        duration: Duration(microseconds: 300),
                        curve: Curves.easeOutCubic,
                        margin: EdgeInsets.symmetric(
                          horizontal: 5,
                        ),
                        width: selectedPage == i ? 25 : 10,
                        height: 10,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12)),
                      )
                  ],
                ))
          ],
        ));
  }
}
