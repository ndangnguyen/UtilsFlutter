import 'package:base/ui/res/icon.dart';
import 'package:base/utils/be_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'overlay_builder.dart';

class ToastWidget {
  final BuildContext context;
  var overLay = OverlayBuilderState();

  ToastWidget(this.context);

  void show({String text, ToastType toastType, Duration duration}) {
    print('overLay.isShowingOverlay(): ${overLay.isShowingOverlay()}');
    if (overLay.isShowingOverlay()) overLay.hideOverlay();
    overLay.context = context;
    var _icon, colorBg;

    switch (toastType) {
      case ToastType.success:
        _icon = Icon(
          Icons.check_circle,
          color: Color(0xff26AA53),
        );
        colorBg = Color(0xffDFF6DE);
        break;
      case ToastType.error:
        _icon = Icon(
          Icons.warning,
          color: Color(0xffAD0000),
        );
        colorBg = Color(0xffFBE2E2);
        break;

      case ToastType.warning:
        _icon = Icon(
          Icons.warning,
          color: Color(0xffFF7C00),
        );
        colorBg = Color(0xffFFF8D7);
        break;
    }

    overLay.child = Container(
      color: colorBg,
      width: MediaQuery
          .of(context)
          .size
          .width - 16,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _icon,
            Container(
              width: 12,
            ),
            Flexible(
              child: BeText(
                text,
                size: 14,
                color: Color(0xff081F42),
              ),
            ),
            GestureDetector(
                onTap: () {
                  overLay.hideOverlay();
                },
                child: FittedBox(
                  child: IconAssets().iconClose20,
                )),
          ],
        ),
      ),
    );
    overLay.showOverlay();

    if (duration == null) {
      duration = Duration(seconds: 3);
    }
    Future.delayed(duration, () {
      if (overLay.isShowingOverlay()) overLay.hideOverlay();
    });
  }
}

enum ToastType { success, warning, error }
