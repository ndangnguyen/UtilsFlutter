import 'package:flutter/material.dart';

class OverlayBuilderState {
  BuildContext context;
  OverlayEntry overlayEntry;
  Widget child;

  OverlayBuilderState({this.context,this.child});

  bool isShowingOverlay() => overlayEntry != null;

  void showOverlay() {
    overlayEntry = new OverlayEntry(builder: (context) {
      return CenterAbout(
        position: Offset(MediaQuery.of(context).size.width / 2,
            MediaQuery.of(context).padding.top + AppBar().preferredSize.height),
        child: Material(child: child)
      );
    });
    addToOverlay(overlayEntry);
  }

  void addToOverlay(OverlayEntry entry) async {
    Overlay.of(context).insert(entry);
  }

  void hideOverlay() {
    print('hideOverlay');
    overlayEntry.remove();
    overlayEntry = null;
  }
}

class CenterAbout extends StatefulWidget {
  final Offset position;
  final Widget child;

  const CenterAbout({Key key, this.position, this.child}) : super(key: key);

  @override
  _CenterAboutState createState() => _CenterAboutState();
}

class _CenterAboutState extends State<CenterAbout> {
  bool isSwitch = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 100), () {
      setState(() {
        isSwitch = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Positioned(
      top: widget.position.dy,
      left: widget.position.dx,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 400),
        opacity: isSwitch ? 0 : 1,
        child: new FractionalTranslation(
          translation: const Offset(-0.5, 0.1),
          child: widget.child,
        ),
      ),
    );
  }
}
