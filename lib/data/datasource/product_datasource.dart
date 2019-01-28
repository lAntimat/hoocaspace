import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoocaspace/data/models/service.dart';
import 'package:hoocaspace/data/result.dart';


abstract class IProductDataSource {
  Future<QuerySnapshot> getProduct();

}

/// Remote data source
class ProductDataSource implements IProductDataSource {

  Future<QuerySnapshot> getProduct() async {
    return Firestore.instance
        .collection("products")
        //.orderBy("date", descending: true)
        .getDocuments();
  }
}
