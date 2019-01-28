import 'dart:async';

import 'package:hoocaspace/data/models/product.dart';
import 'package:hoocaspace/data/result.dart';
import 'package:hoocaspace/data/usecase/product_use_case.dart';
import 'package:hoocaspace/injection/dependency_injection.dart';
import 'package:flutter/services.dart';
import 'package:hoocaspace/data/models/service.dart';

abstract class HomeViewContract {
  onLoadProducts(List<Product> products);

  onError(String msg);

  onUpdateChannel(var result);
}

class HomePresenter {
  HomeViewContract _view;

  HomePresenter(this._view);

  /// Presenter lifecicle
  void init() {
    fetchUsers();
  }

  void dispose() {
  }

  fetchUsers() async {
    Result result = await new ProductUseCase(
        Injector.provideProductDataSource())
        .getProducts();

    if (result.status == Status.ok) {
      _view.onLoadProducts(result.getData());
    } else {
      _view.onError(result.getData().toString());
    }
  }
}
