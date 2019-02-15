import 'dart:async';
import 'dart:developer';

import 'package:hoocaspace/data/datasource/product_datasource.dart';
import 'package:hoocaspace/data/models/categories.dart';
import 'package:hoocaspace/data/models/image_carousel.dart';
import 'package:hoocaspace/data/models/product.dart';
import 'package:hoocaspace/data/models/user.dart';
import 'package:hoocaspace/data/result.dart';
import 'package:hoocaspace/ui/tobacco/tobacco.dart';


abstract class IReservationUseCase {
  Future<Result> getReservations();
}

class ReservationUseCase implements IReservationUseCase {

  IProductDataSource _productDataSource;
  ReservationUseCase(ProductDataSource productDataSource) {
    _productDataSource = productDataSource;
  }

  @override
  Future<Result> getReservations() async {
    Result result;
    await _productDataSource.getReservations()
        .then((data) {
      if (data.documents.isNotEmpty == true) {
        List<Product> ar = List();
        data.documents.forEach((f) {
          ar.add(Product.fromDocument(f));
        });
        result = new Result(Status.ok, ar);
      } else {
        result = new Result(Status.empty, []);
      }
    }).catchError((error) {
      result = new Result(Status.fail, error);
    });

    //debugger(when: result == null);
    return result;
  }
}

