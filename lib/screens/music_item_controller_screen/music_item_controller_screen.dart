import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class MusicListItemControllerScreen extends StatelessWidget {
  const MusicListItemControllerScreen({Key? key}) : super(key: key);

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
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.network(
                            'https://images.unsplash.com/photo-1426604966848-d7adac402bff?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).focusColor,
                                width: 3,
                              ),
                            ),
                          ),
                          Container(
                            height: 140,
                            width: 140,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).focusColor,
                                width: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            options: CarouselOptions(
              pageSnapping: false,
              viewportFraction: 0.5,
              scrollPhysics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
              padEnds: true,
            ),
          )
        ],
      ),
    );
  }
}
