import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hoocaspace/data/models/image_carousel.dart';
import 'package:hoocaspace/data/models/product.dart';
import 'package:hoocaspace/data/models/user.dart';
import 'package:hoocaspace/other/color_constants.dart';
import 'package:hoocaspace/other/text_style.dart';
import 'package:hoocaspace/ui/AddServicePage.dart';
import 'package:hoocaspace/data/models/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoocaspace/ui/home/carousel_widget.dart';
import 'package:hoocaspace/ui/home/home_presenter.dart';
import 'package:hoocaspace/ui/login.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hoocaspace/ui/tobacco/tobacco_shelf.dart';

final List<ImageCarousel> imgList = [];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: ColorConstants.primaryColor,
          primaryColorDark: ColorConstants.primaryColor,
          accentColor: ColorConstants.steelBlue),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }

/*= new FirebaseFirestoreSettings.Builder()
      .setTimestampsInSnapshotsEnabled(true).build();
  firestore.setFirestoreSettings(settings);*/
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> implements HomeViewContract {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  HomePresenter _presenter;
  bool _loading = true;

  String clickedItem = "";
  Iterable<Widget> listTiles;
  List<Product> _products = List();
  String avatarImage = "";
  User user;

  @override
  void initState() {
    super.initState();
    _presenter = new HomePresenter(this);
    _presenter.init();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('HookaSpace'),
          centerTitle: true,
          elevation: 8,
        ),
        floatingActionButton: FloatingActionButton.extended(
            elevation: 4.0,
            icon: const Icon(Icons.add),
            label: const Text("Забронировать"),
            onPressed: () {
              onAddClick("Добавить");
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          color: ColorConstants.primaryColor,
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.notifications),
                color: Colors.white,
                onPressed: () {
                  final snackBar = SnackBar(
                      content: Text('Зовём официанта?'),
                      action: SnackBarAction(
                          label: 'Да :)',
                          textColor: Colors.white,
                          onPressed: () {
                            // Some code to undo the change!
                          }));
                  // Find the Scaffold in the Widget tree and use it to show a SnackBar!
                  _scaffoldKey.currentState.showSnackBar(snackBar);
                },
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: buildCircleAvatar(),
              )
            ],
          ),
        ),
        body: new Container(
          color: ColorConstants.mainBackground,
          child: new Column(
            children: <Widget>[
              _loading ? new Container() : CarouselWidget(imgList).build(),
              new Expanded(
                child: buildListView2(),
              )
            ],
          ),
        ));
  }

  void onAddClick(String str) {
    setState(() {
      clickedItem = str;

      Navigator.push(
        context,
        new MaterialPageRoute(builder: (ctxt) => new LoginPage()),
      );
    });
  }

  void onTobaccoClick() {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (ctxt) => new TobaccoPage()),
    );
  }

  Widget _getHomeDrawer() {
    return Drawer(
      child: Container(
        color: ColorConstants.primaryColor,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Material(
                      color: ColorConstants.primaryColor,
                      type: MaterialType.circle,
                      //borderRadius: BorderRadius.all(Radius.circular(8)),
                      child: InkWell(
                          onTap: () {
                            onAddClick("");
                          },
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(avatarImage),
                            radius: 20,
                          ))),
                  Expanded(
                      flex: 10,
                      child: ListTile(
                        title: Text(user.name ?? "",
                            style: TextStyleConst.titleTextStyle
                                .copyWith(color: Colors.white70)),
                        subtitle: Text(user.phoneNumber ?? "",
                            style: TextStyleConst.commonTextStyle
                                .copyWith(color: Colors.white54)),
                      )),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: Colors.white54,
            ),
            Material(
              color: ColorConstants.primaryColor,
              child: InkWell(
                child: ListTile(
                  leading: Icon(Icons.watch_later, color: Colors.white70),
                  title: Text("Мои заказы",
                      style: TextStyleConst.commonTextStyle
                          .copyWith(color: Colors.white70, fontSize: 16)),
                  onTap: () {},
                ),
              ),
            ),
            Material(
                color: ColorConstants.primaryColor,
                child: InkWell(
                    child: ListTile(
                  leading: Icon(Icons.settings, color: Colors.white70),
                  title: Text("Настройки",
                      style: TextStyleConst.commonTextStyle
                          .copyWith(color: Colors.white70, fontSize: 16)),
                  onTap: () {},
                )))
          ],
        ),
      ),
    );
  }

  Widget buildListView2() {
    var _returnWidget;

    if (_loading) {
      _returnWidget = new Container(
          alignment: FractionalOffset.center,
          child: new CircularProgressIndicator());
    } else {
      List<Widget> children = [];
      _products.forEach((f) {
        children.add(buildPlanetTile(context, f));
      });

      _returnWidget = new ListView(
        padding: EdgeInsets.symmetric(vertical: 4.0),
        children: children,
      );
    }
    return _returnWidget;
  }

  Widget buildListTile(BuildContext context, Service service) {
    return MergeSemantics(
      child: ListTile(
          isThreeLine: true,
          leading: ExcludeSemantics(
              child: CircleAvatar(child: Text(service.name.substring(0, 1)))),
          title: Text(service.name),
          subtitle: Text(service.description),
          onLongPress: () {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => SimpleDialog(
                      children: <Widget>[
                        ListTile(
                          title: Text("Удалить"),
                          onTap: () {
                            Navigator.pop(context);
                            Firestore.instance
                                .collection("service")
                                .document(service.id)
                                .delete()
                                .then((onValue) {
                              setState(() {});
                              _scaffoldKey.currentState.showSnackBar(
                                  SnackBar(content: Text("Успешно удалено")));
                            });
                          },
                        ),
                      ],
                    )).then<String>((String s) {});
          }),
    );
  }

  Widget buildPlanetTile(BuildContext context, Product product) {
    final regularTextStyle = TextStyleConst.baseTextStyle.copyWith(
        color: const Color(0xffb6b2df),
        fontSize: 11.0,
        fontWeight: FontWeight.w400);

    final subHeaderTextStyle = regularTextStyle.copyWith(fontSize: 12.0);

    final planetCardContent = Material(
        color: ColorConstants.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        child: InkWell(
            onTap: () {
              onTobaccoClick();
            },
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child: new Container(
              margin: new EdgeInsets.fromLTRB(76.0, 16.0, 16.0, 16.0),
              //constraints: new BoxConstraints.expand(),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Container(height: 4.0),
                  new Text(
                    product.name,
                    style: TextStyleConst.headerTextStyle,
                    maxLines: 1,
                  ),
                  new Container(height: 8.0),
                  new Text(
                    product.description,
                    style: subHeaderTextStyle,
                    maxLines: 3,
                  ),
                  /*new Container(
              margin: new EdgeInsets.symmetric(vertical: 8.0),
              height: 2.0,
              width: 18.0,
              color: new Color(0xff00c6ff)
          ),*/
                  new Container(height: 20.0),
                  new Row(
                    children: <Widget>[
                      //new Image.asset("assets/img/ic_distance.png", height: 12.0),
                      new Text(
                        product.price.toString(),
                        style: regularTextStyle,
                      ),
                      new Container(width: 24.0),
                      //new Image.asset("assets/img/ic_gravity.png", height: 12.0),
                      new Container(width: 8.0),
                      new Text(
                        product.hardness,
                        style: regularTextStyle,
                      ),
                    ],
                  ),
                ],
              ),
            )));

    final planetThumbnail = new Container(
      margin: new EdgeInsets.symmetric(vertical: 16.0),
      alignment: FractionalOffset.centerLeft,
      child: new Image(
        image: new AssetImage("assets/img/mars.png"),
        height: 92.0,
        width: 92.0,
      ),
    );

    final planetCard = new Container(
      child: planetCardContent,
      //height: 144.0,
      margin: new EdgeInsets.only(left: 46.0),
      decoration: new BoxDecoration(
        color: ColorConstants.primaryColor,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
    );

    return Container(
        //height: 165.0,
        margin: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 24.0,
        ),
        child: new Stack(
          children: <Widget>[
            planetCard,
            planetThumbnail,
          ],
        ));
  }

  Widget buildCircleAvatar() {
    CircleAvatar circleAvatar;
    if (avatarImage == null)
      return Container();
    else {
      circleAvatar = avatarImage.isEmpty
          ? null
          : CircleAvatar(
              backgroundImage: NetworkImage(avatarImage),
              radius: 12,
            );

      return Material(
          color: ColorConstants.primaryColor,
          type: MaterialType.circle,
          //borderRadius: BorderRadius.all(Radius.circular(8)),
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) => _getHomeDrawer(),
              );
            },
            child: Padding(padding: EdgeInsets.all(8), child: circleAvatar),
          ));
    }
  }

  @override
  onError(String msg) {
    print("main error " + msg);
    setState(() => _loading = false);
  }

  @override
  onLoadProducts(List<Product> products) {
    _products.clear();
    _products.addAll(products);
    setState(() => _loading = false);
  }

  @override
  onLoadImageCarousel(List<ImageCarousel> images) {
    imgList.clear();
    imgList.addAll(images);
    setState(() => _loading = false);
  }

  @override
  onUpdateChannel(result) {
    // TODO: implement onUpdateChannel
    return null;
  }

  @override
  onLoadUser(User user) {
    this.user = user;
    debugPrint("onLoadUser userImg = " + user.imageUrl);
    setState(() {
      avatarImage = user.imageUrl;
    });
  }
}
