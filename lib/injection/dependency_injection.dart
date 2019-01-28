import 'package:hoocaspace/data/datasource/product_datasource.dart';
import 'package:flutter/services.dart';

enum Flavor {
  MOCK,
  PROD,
  STAGE
}

class Injector {

  static final Injector _singleton = new Injector._internal();

  static Flavor _flavor;

  static void configure(Flavor flavor) {
    _flavor = flavor;
  }

  static Flavor getFlavor() {
    return _flavor;
  }

  static const MethodChannel methodChanel = const MethodChannel(
      'clean.flutter.io/cameraResult');

  static const EventChannel eventChannel = const EventChannel(
      'clean.flutter.io/stream');

  factory Injector() {
    return _singleton;
  }

  static ProductDataSource provideProductDataSource() {
    return new ProductDataSource();
  }

  Injector._internal();

}