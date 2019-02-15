import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hoocaspace/data/models/service.dart';
import 'package:hoocaspace/data/models/user.dart';
import 'package:hoocaspace/data/result.dart';

abstract class IProductDataSource {
  Future<Result> saveUser(User user);
  Future<Result> getUser();
  Future<QuerySnapshot> getProduct();
  Future<QuerySnapshot> getImageCarousel();
  Future<QuerySnapshot> getTobacco();
  Future<QuerySnapshot> getTobaccoCategories();
  Future<QuerySnapshot> getReservations();
}

/// Remote data source
class ProductDataSource implements IProductDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore fb = Firestore.instance;

  @override
  Future<Result> saveUser(User user) async {
    Result result;
    fb.collection("user").document(user.id).setData(user.toMap()).whenComplete(() {
      result = new Result(Status.ok, true);
    }).catchError((onError) {
      result = new Result(Status.fail, onError);
    });

    /*fb.runTransaction((transaction) async {
      await transaction.set(
          fb.collection("users").document(user.id), user.toMap());
    }).whenComplete(() {
      result = new Result(Status.ok, true);
    }).catchError((onError) {
      result = new Result(Status.fail, onError);
    });*/
    return result;
  }

  @override
  Future<Result> getUser() async {
    FirebaseUser currentUser = await _auth.currentUser();
    Result result;

    await Firestore.instance
        .collection("user").document(currentUser.uid).get()
        //.where("id", isEqualTo: currentUser.uid)
        //.getDocuments()
        .then((data) {
      if (data.exists) {
        User user;
          user = new User.fromDocument(data);
          result = new Result(Status.ok, user);
      } else {
        result = new Result(Status.fail, []);
      }
    }).catchError((onError) {
      result = new Result(Status.fail, onError);
    });

    return result;
  }

  @override
  Future<QuerySnapshot> getProduct() async {
    return Firestore.instance
        .collection("products")
        //.orderBy("date", descending: true)
        .getDocuments();
  }

  @override
  Future<QuerySnapshot> getImageCarousel() async {
    return Firestore.instance
        .collection("image_carousel")
        .orderBy("order", descending: false)
        .getDocuments();
  }

  @override
  Future<QuerySnapshot> getTobacco() {
    return Firestore.instance
        .collection("tobacco")
        //.orderBy("order", descending: false)
        .getDocuments();
  }

  @override
  Future<QuerySnapshot> getTobaccoCategories() {
    return Firestore.instance
        .collection("tobaccoCategories")
        .orderBy("order", descending: false)
        .getDocuments();
  }

  @override
  Future<QuerySnapshot> getReservations() {
    return Firestore.instance
        .collection("reservations")
        .orderBy("timestamp", descending: false)
        .getDocuments();
  }
}
