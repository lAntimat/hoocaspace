import 'dart:async';
import 'dart:developer';

import 'package:hoocaspace/data/datasource/product_datasource.dart';
import 'package:hoocaspace/data/models/categories.dart';
import 'package:hoocaspace/data/models/image_carousel.dart';
import 'package:hoocaspace/data/models/product.dart';
import 'package:hoocaspace/data/models/user.dart';
import 'package:hoocaspace/data/result.dart';
import 'package:hoocaspace/ui/tobacco/tobacco.dart';


abstract class IProductUseCase {
  Future<Result> saveUser(User user);
  Future<Result> getUser();
  Future<Result> getProducts();
  Future<Result> getImageCarousel();
  Future<Result> getTobacco();
  Future<Result> getTobaccoCategories();
}

class ProductUseCase implements IProductUseCase {

  IProductDataSource _productDataSource;
  ProductUseCase(ProductDataSource productDataSource) {
    _productDataSource = productDataSource;
  }

  @override
  Future<Result> getProducts() async {
    Result result;
    await _productDataSource.getProduct()
        .then((data) {
      if (data.documents.isNotEmpty == true) {
        List<Product> ar = List();
        data.documents.forEach((f) {
          ar.add(Product.fromDocument(f));
        });
        result = new Result(Status.ok, ar);
      } else {
        result = new Result(Status.fail, []);
      }
    }).catchError((error) {
      result = new Result(Status.fail, error);
    });

    //debugger(when: result == null);
    return result;
  }

  @override
  Future<Result> getImageCarousel() async {
    Result result;
    await _productDataSource.getImageCarousel()
        .then((data) {
      if (data.documents.isNotEmpty == true) {
        List<ImageCarousel> ar = List();
        data.documents.forEach((f) {
          ar.add(ImageCarousel.fromDocument(f));
        });
        result = new Result(Status.ok, ar);
      } else {
        result = new Result(Status.fail, []);
      }
    }).catchError((error) {
      result = new Result(Status.fail, error);
    });
    //debugger(when: result == null);
    return result;
  }

  @override
  Future<Result> getUser() async {
    return _productDataSource.getUser();
  }

  @override
  Future<Result> saveUser(User user) {
    return _productDataSource.saveUser(user);
  }

  @override
  Future<Result> getTobacco() async {
    Result result;
    await _productDataSource.getTobacco()
        .then((data) {
      if (data.documents.isNotEmpty == true) {
        List<Tobacco> ar = List();
        data.documents.forEach((f) {
          ar.add(Tobacco.fromDocument(f));
        });
        result = new Result(Status.ok, ar);
      } else {
        result = new Result(Status.fail, []);
      }
    }).catchError((error) {
      result = new Result(Status.fail, error);
    });
    //debugger(when: result == null);
    return result;
  }

  @override
  Future<Result> getTobaccoCategories() async {
    Result result;
    await _productDataSource.getTobaccoCategories()
        .then((data) {
      if (data.documents.isNotEmpty == true) {
        List<CategoryName> ar = List();
        data.documents.forEach((f) {
          ar.add(CategoryName.fromDocument(f));
        });
        result = new Result(Status.ok, ar);
      } else {
        result = new Result(Status.fail, []);
      }
    }).catchError((error) {
      result = new Result(Status.fail, error);
    });
    //debugger(when: result == null);
    return result;
  }
}

