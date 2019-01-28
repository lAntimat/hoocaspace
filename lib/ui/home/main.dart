import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hoocaspace/data/models/product.dart';
import 'package:hoocaspace/other/color_constants.dart';
import 'package:hoocaspace/ui/AddServicePage.dart';
import 'package:hoocaspace/data/models/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoocaspace/ui/home/home_presenter.dart';
import 'package:hoocaspace/ui/text_style.dart';
import 'package:carousel_slider/carousel_slider.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

final List carouselItems = map<Widget>(imgList, (index, i) {
  return Container(
      margin: EdgeInsets.all(5.0),
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Stack(
            children: <Widget>[
              Image.network(
                i,
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
                        'Акция номер $index',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ))),
            ],
          )));
}).toList();

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: ColorConstants.primaryColor,
          primaryColorDark: ColorConstants.primaryColor,
          accentColor: ColorConstants.primaryColor),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
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
            title: const Text('HoocaSpace'),
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
                icon: Icon(Icons.menu),
                color: Colors.white,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) => _getHomeDrawer(),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.search),
                color: Colors.white,
                onPressed: () {
                  onAddClick("Поиск");
                },
              ),
            ],
          ),
        ),
        body: new Container(
          color: ColorConstants.mainBackground,
          child: new Column(
            children: <Widget>[
              buildCarousel(),
              new Expanded(
                child: buildListView2(),
              )
            ],
          ),
        )
        );
  }

  void onAddClick(String str) {
    setState(() {
      clickedItem = str;

      Navigator.push(
        context,
        new MaterialPageRoute(builder: (ctxt) => new AddServicePage()),
      );
    });
  }

  Widget _getHomeDrawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          const ListTile(
            leading: const Icon(Icons.directions_car),
            title: const Text("Мои автомобили"),
          ),
          const ListTile(
            leading: const Icon(Icons.archive),
            title: const Text("Архив"),
          )
        ],
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
    final regularTextStyle = Style.baseTextStyle.copyWith(
        color: const Color(0xffb6b2df),
        fontSize: 11.0,
        fontWeight: FontWeight.w400);

    final subHeaderTextStyle = regularTextStyle.copyWith(fontSize: 12.0);

    final planetCardContent = Material(
      color: ColorConstants.primaryColor,
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: InkWell(
          onTap: () {},
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
            style: Style.headerTextStyle,
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
              )
    );
  }

  Widget buildCarousel() {
    return CarouselSlider(
        items: carouselItems,
        autoPlay: false,
        viewportFraction: 0.8,
        aspectRatio: 2.0,
        distortion: false
    );
  }

  @override
  onError(String msg) {
    print("main error " + msg);
  }

  @override
  onLoadProducts(List<Product> products) {
    _products.addAll(products);
    setState(() => _loading = false);
  }

  @override
  onUpdateChannel(result) {
    // TODO: implement onUpdateChannel
    return null;
  }
}
