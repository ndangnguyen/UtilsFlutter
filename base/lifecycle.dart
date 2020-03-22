import 'package:base/base/system_lifecycle_listener.dart';
import 'package:base/utils/system_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

abstract class LifeCycleState<T extends StatefulWidget> extends State<T>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    SystemLifecycleListener.instance.addCallback(handleLifeCycleCallback);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      onFirstFrame();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  void handleLifeCycleCallback(AppLifeCycle lifeCycle) {
    if (lifeCycle == AppLifeCycle.onResume) {
      onResume();
    } else if (lifeCycle == AppLifeCycle.onPause) {
      hideKeyboard();
      onPause();
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    SystemLifecycleListener.instance.removeCallback(handleLifeCycleCallback);
    super.dispose();
  }

  void onResume() {}

  void onPause() {}

  void onFirstFrame() {}

  RouteObserver<Route> get routeObserver;

  @override
  void didPopNext() {
    SystemLifecycleListener.instance.addCallback(handleLifeCycleCallback);
    onResume();
  }

  @override
  void didPushNext() {
    SystemLifecycleListener.instance.removeCallback(handleLifeCycleCallback);
    hideKeyboard();
    onPause();
  }

  @override
  void didPop() {}

  @override
  void didPush() {}
}
