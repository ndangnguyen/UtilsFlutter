import 'dart:async';

import 'package:base/base/lifecycle.dart';
import 'package:base/router/router.dart';
import 'package:flutter/material.dart';

/// Manages showing and closing dialogs.
/// Automatically closes existing dialog when showing a new dialog
///
/// E.g:
/// DialogManager.show(context: context, builder: (){
///   return Container();
/// });
class DialogManager {
  /// Shows a dialog with a default fade transition and transparent barrier color
  ///
  /// `barrierDismissible`: dialog can be closed by pressing the barrier
  /// `transitionBuilder`: customize transition animation. See [RouteTransitionsBuilder]
  /// `transitionDuration`: customize transition duration
  /// `barrierColor`: customize barrier color
  /// `builder`: a [DialogBuilder], return the content of the dialog to show in the center of the screen
  static Future<T> show<T>(
      {@required BuildContext context,
      @required DialogBuilder builder,
      bool barrierDismissible = true,
      bool overlay = false,
      Alignment dialogAlignment = Alignment.center,
      RouteTransitionsBuilder transitionBuilder,
      Duration transitionDuration = const Duration(milliseconds: 150),
      Color barrierColor = const Color(0x00FFFFFF)}) async {
    assert(builder != null);
    assert(context != null);

    _checkAndCloseVisibleDialog(context, overlay);

    return await showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          final ThemeData theme = Theme.of(context, shadowThemeOnly: true);
          final Widget pageChild = Builder(builder: (context) {
            return BaseDialog(
              builder: builder,
              alignment: dialogAlignment,
              onPop: () {},
            );
          });
          return Builder(builder: (BuildContext context) {
            return theme != null
                ? Theme(data: theme, child: pageChild)
                : pageChild;
          });
        },
        barrierDismissible: barrierDismissible,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: barrierColor,
        transitionDuration: transitionDuration,
        transitionBuilder: transitionBuilder ??
            (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation, Widget child) {
              return FadeTransition(
                opacity:
                    CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                child: child,
              );
            });
  }

  static void _checkAndCloseVisibleDialog(BuildContext context, bool overlay) {
    if (!overlay) {
      Navigator.of(context).popUntil((route) => route is PageRoute);
    }
  }
}

typedef DialogBuilder = Widget Function(BuildContext context);

class BaseDialog extends StatefulWidget {
  final DialogBuilder builder;

  final Function onPop;

  final Alignment alignment;

  BaseDialog({this.builder, this.onPop, this.alignment});

  @override
  _BaseDialogState createState() => _BaseDialogState();
}

class _BaseDialogState extends LifeCycleState<BaseDialog> with RouteAware {
  @override
  void didPop() {
    widget.onPop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: widget.alignment,
      child: Material(
        child: widget.builder(context),
        color: Colors.transparent,
      ),
    );
  }

  @override
  RouteObserver<Route> get routeObserver => Router.instance.routeObserver;
}
