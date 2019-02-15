import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoocaspace/data/models/image_carousel.dart';
import 'package:hoocaspace/data/models/product.dart';
import 'package:hoocaspace/data/models/user.dart';
import 'package:hoocaspace/data/result.dart';
import 'package:hoocaspace/data/usecase/product_use_case.dart';
import 'package:hoocaspace/injection/dependency_injection.dart';
import 'package:flutter/services.dart';
import 'package:hoocaspace/data/models/service.dart';

abstract class HomeViewContract {
  onLoadProducts(List<Product> products);
  onLoadImageCarousel(List<ImageCarousel> products);
  onLoadUser(User user);
  onError(String msg);
  onUpdateChannel(var result);
}

class HomePresenter {
  HomeViewContract _view;

  HomePresenter(this._view);

  IProductUseCase useCase = ProductUseCase(Injector.provideProductDataSource());

  /// Presenter lifecicle
  void init() async {
    final Firestore firestore = Firestore.instance;
    await firestore.settings(persistenceEnabled: true, timestampsInSnapshotsEnabled: true);
    fetchUsers();
  }

  void dispose() {}

  fetchUsers() async {
    Result products;
    Result imagesCarousel;
    Result user;
    await Future.wait([useCase.getProducts(), useCase.getImageCarousel(), useCase.getUser()])
        .then((List responses) {
          products = responses[0];
          imagesCarousel = responses[1];
          user = responses[2];
    });

    if (products.status == Status.ok) {
      _view.onLoadProducts(products.getData());
    } else {
      _view.onError(products.getData().toString());
    }

    if (imagesCarousel.status == Status.ok) {
      _view.onLoadImageCarousel(imagesCarousel.getData());
    } else {
      _view.onError(imagesCarousel.getData().toString());
    }

    if (user.status == Status.ok) {
      _view.onLoadUser(user.getData());
    } else {
      _view.onError(user.getData().toString());
    }
  }
}
