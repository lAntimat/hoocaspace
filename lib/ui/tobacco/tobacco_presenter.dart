import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoocaspace/data/models/categories.dart';
import 'package:hoocaspace/data/models/image_carousel.dart';
import 'package:hoocaspace/data/models/product.dart';
import 'package:hoocaspace/data/models/user.dart';
import 'package:hoocaspace/data/result.dart';
import 'package:hoocaspace/data/usecase/product_use_case.dart';
import 'package:hoocaspace/injection/dependency_injection.dart';
import 'package:flutter/services.dart';
import 'package:hoocaspace/data/models/service.dart';
import 'package:hoocaspace/ui/tobacco/tobacco.dart';

abstract class TobaccoViewContract {
  onLoadData(List<Tobacco> products);
  onLoadCategories(List<CategoryName> categories);
  onError(String msg);
}

class TobaccoPresenter {
  TobaccoViewContract _view;

  TobaccoPresenter(this._view);

  IProductUseCase useCase = ProductUseCase(Injector.provideProductDataSource());

  /// Presenter lifecicle
  void init() async {
    fetchData();
  }

  void dispose() {}

  fetchData() async {
    Result tobacco;
    Result tobaccoCategories;
    await Future.wait([useCase.getTobacco(), useCase.getTobaccoCategories()])
        .then((List responses) {
      tobacco = responses[0];
      tobaccoCategories = responses[1];
    });

    if (tobacco.status == Status.ok) {
      _view.onLoadData(tobacco.getData());
    } else {
      _view.onError(tobacco.getData().toString());
    }

    if (tobaccoCategories.status == Status.ok) {
      _view.onLoadCategories(tobaccoCategories.getData());
    } else {
      _view.onError(tobacco.getData().toString());
    }
  }
}
