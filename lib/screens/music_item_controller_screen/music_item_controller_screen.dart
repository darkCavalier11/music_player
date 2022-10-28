import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class MusicItemControllerScreen extends StatelessWidget {
  const MusicItemControllerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        alignment: Alignment.center,
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 25,
              sigmaY: 35,
            ),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor.withOpacity(0.1),
              ),
            ),
          ),
          CarouselSlider(
            items: List.generate(10, (index) {
              return Container(
                color: Colors.redAccent,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1426604966848-d7adac402bff?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              );
            }),
            options: CarouselOptions(
              pageSnapping: false,
              viewportFraction: 0.4,
              scrollPhysics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
            ),
          )
        ],
      ),
    );
  }
}
