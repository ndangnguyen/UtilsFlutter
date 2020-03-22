import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SystemLifecycleListener {
  static final instance = SystemLifecycleListener();

  final _callbacks = Set<AppLifeCycleCallback>();

  void _invokeCallbacks(AppLifeCycle lifeCycle) {
    for (AppLifeCycleCallback callback in _callbacks) {
      callback(lifeCycle);
    }
  }

  void addCallback(AppLifeCycleCallback callback) {
    _callbacks.add(callback);
  }

  void removeCallback(AppLifeCycleCallback callback) {
    _callbacks.remove(callback);
  }

  SystemLifecycleListener() {
    setHandler();
  }

  void setHandler() {
    // ignore: missing_return
    SystemChannels.lifecycle.setMessageHandler((msg) {
      if (msg.toString() == AppLifecycleState.resumed.toString()) {
        _invokeCallbacks(AppLifeCycle.onResume);
      } else if (msg.toString() == AppLifecycleState.paused.toString()) {
        _invokeCallbacks(AppLifeCycle.onPause);
      } else if (msg.toString() == AppLifecycleState.inactive.toString()) {
        _invokeCallbacks(AppLifeCycle.onPause);
      }
    });
  }
}

enum AppLifeCycle { onPause, onResume }

typedef AppLifeCycleCallback = void Function(AppLifeCycle lifeCycle);
