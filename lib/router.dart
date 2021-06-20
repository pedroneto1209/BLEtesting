import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voltzble/cubit/ble_cubit.dart';
import 'package:voltzble/cubit/nav_cubit.dart';
import 'package:voltzble/home.dart';
import 'package:voltzble/main.dart';
import 'package:voltzble/nav.dart';

class AppRouter {
  final BleCubit _bleCubit = BleCubit();
  final NavCubit _navCubit = NavCubit();

  Route onGeneratedRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(providers: [
                  BlocProvider.value(value: _bleCubit),
                ], child: MyHomePage()));
        break;
      case '/home':
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(providers: [
                  BlocProvider.value(value: _bleCubit),
                ], child: HomeWidget()));
        break;
      case '/nav':
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(providers: [
                  BlocProvider.value(value: _navCubit),
                ], child: NavPage()));
        break;
      default:
        return null;
    }
  }

  void dispose() {
    _bleCubit.close();
    _navCubit.close();
  }
}
