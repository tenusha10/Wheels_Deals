import 'package:flutter/material.dart';

class ImageSwipe extends StatefulWidget {
  final List imageList;

  ImageSwipe({this.imageList});

  @override
  State<ImageSwipe> createState() => _ImageSwipeState();
}

class _ImageSwipeState extends State<ImageSwipe> {
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
                for (var i = 0; i < widget.imageList.length; i++)
                  Container(
                    child: Image.network(
                      "${widget.imageList[i]}",
                      fit: BoxFit.cover,
                    ),
                  )
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
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12)),
                      )
                  ],
                ))
          ],
        ));
  }
}
