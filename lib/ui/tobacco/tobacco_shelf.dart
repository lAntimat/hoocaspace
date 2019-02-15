import 'package:flutter/material.dart';
import 'package:hoocaspace/data/models/categories.dart';
import 'package:hoocaspace/other/Utils/cached_network_image.dart';
import 'package:hoocaspace/other/Utils/utils.dart';
import 'package:hoocaspace/other/color_constants.dart';
import 'package:hoocaspace/other/text_style.dart';
import 'package:hoocaspace/ui/tobacco/tobacco.dart';
import 'package:hoocaspace/ui/tobacco/tobacco_presenter.dart';
import 'package:hoocaspace/ui/tobacco/tobacco_row.dart';

class TobaccoPage extends StatefulWidget {
  TobaccoPage({Key key}) : super(key: key);

  @override
  _TobaccoShelf createState() => _TobaccoShelf();
}

class _TobaccoShelf extends State<TobaccoPage> implements TobaccoViewContract {
  TobaccoPresenter _presenter;
  bool _loading = true;

  List<CategoryName> categories = List();

  //List<CategoryName> categories = [CategoryName("Level 1"), CategoryName("Level 2"), CategoryName("Level 3")];
  List<Tobacco> tobaccos = List();

  @override
  void initState() {
    super.initState();
    _presenter = new TobaccoPresenter(this);
    _presenter.init();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: _loading
            ? AppBar(
                centerTitle: true,
                title: Text("Табаки"),
              )
            : null,
        body: getScaffoldBody());
  }

  @override
  onError(String msg) {
    // TODO: implement onError
    return null;
  }

  @override
  onLoadCategories(List<CategoryName> categories) {
    this.categories.clear();
    this.categories.addAll(categories);
  }

  @override
  onLoadData(List<Tobacco> tobaccos) {
    this.tobaccos.clear();
    this.tobaccos.addAll(tobaccos);

    setState(() {
      _loading = false;
    });
  }

  Widget getScaffoldBody() {
    if (_loading) {
      return Container(
        padding: EdgeInsets.all(36),
        width: double.infinity,
        height: double.infinity,
        color: ColorConstants.primaryColor,
        child: CircularProgressIndicator(),
      );
    } else {
      return DefaultTabController(
        length: categories.length,
        child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  elevation: 0,
                  expandedHeight: 0.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text("Табаки",
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  ),
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    new TabBar(
                      indicatorPadding:
                          EdgeInsets.only(left: 16.0, right: 16.0),
                      indicatorWeight: 3.0,
                      isScrollable: true,
                      labelColor: ColorConstants.white,
                      tabs: categories.map((CategoryName category) {
                        return new Tab(text: category.categoryName);
                      }).toList(),
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
                children: categories.map((CategoryName category) {
              if (categories.length > 0 && tobaccos.length > 0)
                return getBody(tobaccos
                    .where((Tobacco tobacco) => Utils.equalsIgnoreCase(
                        tobacco.hardnessCategoryById, category.categoryName))
                    .toList());
            }).toList())),
      );
    }
  }

  Widget getBody(List<Tobacco> t) {
    Map s = Map();

    t.forEach((Tobacco t) => s[t.categoryByName] = "");

    return Scaffold(
      body: SingleChildScrollView(
        child: new Container(
          color: ColorConstants.mainBackground,
          child:  new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              /*new Hero(
                tag: 'image-hero',
                child: new Container(
                  margin: const EdgeInsets.only(bottom: 20.0),
                  child: new CachedNetworkImage(
                    imageUrl:
                        "https://pp.userapi.com/c837534/v837534729/1ad2f/R-_0b3V528k.jpg",
                    width: 120.0,
                    height: 120.0,
                    fit: BoxFit.cover,
                  ),
                )),
            new Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              child: new Text('Наслаждайся. Дыми. Отдыхай.',
                  style: TextStyleConst.subTitleTextStyle.copyWith(
                    fontSize: 18.0,
                    color: Colors.white,
                  )),
            ),*/
              new Container(
                //height: 450.0,
                width: double.infinity,
                decoration: new BoxDecoration(
                  //borderRadius: new BorderRadius.only(
                  //  topLeft: const Radius.circular(30.0),
                  //topRight: const Radius.circular(30.0)),
                  color: ColorConstants.primaryColor,
                ),
                child: new Column(
                  children: s.keys.map((key) {
                    return Column(
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(left: 36, top: 16),
                            width: double.infinity,
                            child: Text(
                              key,
                              style: TextStyleConst.headerTextStyle,
                            )),
                        new TobaccoRow(t
                            .where((Tobacco tobacco) => Utils.equalsIgnoreCase(
                                tobacco.categoryByName, key))
                            .toList()),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      width: double.infinity,
      color: ColorConstants.primaryColor,
      child: Center(
        child: _tabBar,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
