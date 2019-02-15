import 'package:hoocaspace/other/Utils/cached_network_image.dart';
import 'package:hoocaspace/other/color_constants.dart';
import 'package:hoocaspace/other/text_style.dart';
import 'package:hoocaspace/ui/tobacco/tobacco.dart';
import 'package:flutter/material.dart';

class TobaccoRow extends StatelessWidget {



  PageController pageController = new PageController(viewportFraction: 0.85);
  List<Tobacco> tobacco;

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 340.0,
      width: double.infinity,
      child: new PageView(
          controller: pageController,
          children: tobacco.map((Tobacco tobacco) {
            return Padding(
              padding: EdgeInsets.all(10.0),
              child: new Container(
                decoration: new BoxDecoration(
                  color: ColorConstants.mainBackground,
                  shape: BoxShape.rectangle,
                  borderRadius: new BorderRadius.circular(10.0),
                  boxShadow: <BoxShadow>[
                    new BoxShadow(
                        color: Colors.black38,
                        blurRadius: 2.0,
                        spreadRadius: 1.0,
                        offset: new Offset(0.0, 2.0)),
                  ],
                ),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    new Container(
                      height: 180.0,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0)),
                        child: new CachedNetworkImage(
                            imageUrl: tobacco.imgUrl, fit: BoxFit.cover),
                      )
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, bottom: 10.0, top: 10.0),
                      child: new Text(tobacco.title,
                          style: TextStyleConst.titleTextStyle.copyWith(fontSize: 25.0),
                          textAlign: TextAlign.right),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(left: 20.0, bottom: 10.0),
                      child: new Text(tobacco.subTitle,
                      style: TextStyleConst.subTitleTextStyle.copyWith(fontSize: 14)),
                    ),
                    new Container(
                      margin: const EdgeInsets.only(left: 20.0),
                      decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.circular(20.0)),
                      child: new ClipRRect(
                        borderRadius: new BorderRadius.circular(50.0),
                        child: new MaterialButton(
                          minWidth: 70.0,
                          onPressed: () {},
                          color: ColorConstants.primaryColor,
                          child: new Text('Забить',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList()),
    );
  }

  TobaccoRow(this.tobacco);
}
