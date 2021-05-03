import 'package:flutter/material.dart';
import 'package:voltzble/home.dart';
import 'package:voltzble/main.dart';

class AppRouter {
  Route onGeneratedRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MyHomePage());
        break;
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeWidget());
        break;
      default:
        return null;
    }
  }
}
