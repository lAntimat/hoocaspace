import 'dart:async';
import 'dart:developer';

import 'package:hoocaspace/data/datasource/product_datasource.dart';
import 'package:hoocaspace/data/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoocaspace/data/result.dart';

class ProductUseCase {

  ProductDataSource _productDataSource;
  ProductUseCase(ProductDataSource productDataSource) {
    _productDataSource = productDataSource;
  }

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

  //convert to ui model
  /*Result<List<User>> asUIContent(Result<List<UserSource>> resultSource) {
    List<User> resultList = new List<User>();
    if (resultSource.getData() != null) {
      resultSource.getData().forEach((u) => resultList.add(new User(u)));
    }
    return new Result(resultSource.status, resultList);
  }*/
}