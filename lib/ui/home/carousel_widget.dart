
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hoocaspace/data/models/image_carousel.dart';
import 'package:hoocaspace/other/Utils/cached_network_image.dart';

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }
  return result;
}

class CarouselWidget {
  List<ImageCarousel> imgList = [];
  List carouselItems;

  CarouselWidget(this.imgList) {

    carouselItems = map<Widget>(imgList, (index, i) {
      return Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  new CachedNetworkImage(
                    imageUrl: imgList[index].url,
                    //placeholder: new CircularProgressIndicator(),
                    fit: BoxFit.cover,
                    width: 1000.0,
                  ),
                  Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              )),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Text(
                            imgList[index].title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ))),
                ],
              )));
    }).toList();
  }

  Widget build() {
    return CarouselSlider(
        items: carouselItems,
        autoPlay: true,
        autoPlayDuration: const Duration(seconds: 2),
        interval: const Duration(seconds: 8),
        viewportFraction: 0.8,
        aspectRatio: 2.0,
        distortion: false
    );
  }
}