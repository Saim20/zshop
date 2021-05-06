// @dart=2.9
import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:z_shop/appState.dart';

void main() {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

