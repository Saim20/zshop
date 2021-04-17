import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:z_shop/appState.dart';
import '';

void main() {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

