import 'package:base/base/lifecycle.dart';
import 'package:base/language_manager/language/lang_en.dart';
import 'package:base/language_manager/language/lang_vi.dart';
import 'package:base/router/router.dart';
import 'package:flutter/material.dart';

import '../language_manager/language_manager.dart';

/// Provides common utilities and functions to build ui and handle app lifecycle
abstract class BaseState<T extends StatefulWidget> extends LifeCycleState<T> {
  Size screenSize;

  Size designScreenSize;

  /// Called when the app is temporarily closed or a new route is pushed
  @override
  void onPause() {}

  /// Called when users return to the app or the adjacent route of this widget is popped
  @override
  void onResume() {}

  /// Called once when this state's widget finished building
  @override
  void onFirstFrame() {}


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenSize = MediaQuery.of(context).size;
    designScreenSize = getDesignSize() ?? Size(360.0, 640.0);

   LanguageManager.ins.stream.listen(handleSetState);
  }

  handleSetState(data){
    if(mounted) setState(() {
    });
  }

  String getLocale({String key}) {
    if (LanguageManager.ins.isVie) {
      return langVi[key];
    } else {
      return langEn[key];
    }
  }

  /// Override to define new design size for ui
  Size getDesignSize() => null;

  String get packageName => null;

  /// Scale the provided 'designSize' proportionally to the screen's width
  double scaleWidth(num designSize, {bool preventScaleDown = false}) {
    if (designSize == null) return null;
    final scaledSize = screenSize.width * designSize / designScreenSize.width;

    if (preventScaleDown && scaledSize < designSize) {
      return designSize?.toDouble();
    }

    return scaledSize;
  }

  /// Scale the provided 'designSize' proportionally to the screen's height
  double scaleHeight(num designSize, {bool preventScaleDown = false}) {
    if (designSize == null) return null;

    final scaledSize = screenSize.height * designSize / designScreenSize.height;

    if (preventScaleDown && scaledSize < designSize) {
      return designSize?.toDouble();
    }

    return scaledSize;
  }

  Widget buildAssetsImage(String path,
      {BoxFit fit = BoxFit.contain, num width, num height, String package}) {
    return Image.asset(path,
        height: height?.toDouble(),
        width: width?.toDouble(),
        package: package ?? packageName,
        fit: fit);
  }

  DecorationImage buildDecorationImage(String path,
      {BoxFit fit = BoxFit.contain, ColorFilter filter, String package}) {
    return DecorationImage(
        image: AssetImage(path, package: package ?? packageName),
        fit: fit,
        colorFilter: filter);
  }

  @override
  RouteObserver<Route> get routeObserver => Router.instance.routeObserver;
}
