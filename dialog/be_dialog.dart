import 'package:base/ui/res/icon.dart';
import 'package:base/utils/be_text.dart';
import 'package:base/utils/string_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dialog_manager.dart';

/// Method [showBeDialog] dùng để show popup chuẩn của app be.
/// Các param truyền không cần bắt buộc khác null, ngoài [context].
/// Field [isHideClose] mặc định = false, muốn ẩn icon Close thì truyền true
/// Field [icon] nếu không truyền thì sẽ không có icon trong popup.
/// listAction là 1 list các Widget có kiểu là [buildActionDialog]
/// Ví dụ cách dùng:
/// showBeDialog(
///   context: context,
///   title: "Day la title",
///   desc: "day la phan mo ta",
///   listAction: [
///     buildActionDialog(
///       text: "Button 1",
///       colorBackground: Colors.red,
///       onTap:(){
///         // Thuc hien action khi click vao day
///       }
///     ),
///     buildActionDialog(
///       text: "Button 2",
///       colorBackground: Colors.white,
///       onTap:(){
///         // Thuc hien action khi click vao day
///       }
///     ),
///   ]
/// );
///
/// listAction nếu null xem như không có button action nào.
///

void showBeDialog({BuildContext context,
  Widget title,
  Widget desc,
  bool isHideClose = false,
  Widget icon,
  bool barrierDismissible = true,
  bool isHorizontal = false,
  List<Widget> listAction}) {
  assert(context != null);
  DialogManager.show(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
//            Navigator.pop(context);
          },
          child: BeDiaLog(
            title: title,
            desc: desc,
            isHorizontal: isHorizontal,
            icon: icon,
            isHideClose: isHideClose,
            listAction: listAction,
          ),
        );
      });
}

class BeDiaLog extends StatefulWidget {
  final Widget title, desc;
  final Widget icon;
  final List<Widget> listAction;
  final bool isHideClose, isHorizontal;

  const BeDiaLog({Key key,
    this.title,
    this.icon,
    this.isHorizontal,
    this.desc,
    this.listAction,
    this.isHideClose})
      : super(key: key);

  @override
  _BeDiaLogState createState() => _BeDiaLogState();
}

class _BeDiaLogState extends State<BeDiaLog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 24,
              ),
              _buildIcon(),
              _buildTitle(),
              _buildDercs(),
              SizedBox(
                height: 24,
              ),
              _buildListAction(),
              _space(24, isBottom: true),
            ],
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
    );
  }

  Widget _space(double h, {bool isTop = false, bool isBottom = false}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isTop ? 2 : 0),
                topRight: Radius.circular(isTop ? 2 : 0),
                bottomRight: Radius.circular(isBottom ? 2 : 0),
                bottomLeft: Radius.circular(isBottom ? 2 : 0))),
        height: h,
      ),
    );
  }

  Widget _buildListAction() {
    if (widget.listAction == null || widget.listAction.length == 0)
      return Container();
    return GestureDetector(
      onTap: () {},
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: widget.isHorizontal
              ? Row(
            children: widget.listAction,
          )
              : Column(
            children: widget.listAction,
          )),
    );
  }

  Widget _buildDercs() {
    if (widget.desc == null) return Container();
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(left: 24, right: 24, top: 0),
        width: double.infinity,
        child: widget.desc,
      ),
    );
  }

  Widget _buildIcon() {
    if (widget.icon == null) return Container();
    return Container(
        height: 70,
        margin: EdgeInsets.only(left: 20,bottom: 4),
        child: Align(alignment: Alignment.centerLeft, child: widget.icon));
  }

  Widget _buildTitle() {
    if (widget.title == null) return Container();
    return GestureDetector(
      onTap: () {},
      child: Container(
          padding: EdgeInsets.only(left: 24, right: 16,bottom: 12),
          width: double.infinity,
          child: Stack(
            children: <Widget>[
              widget.title,
              widget.isHideClose
                  ? Container()
                  : Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: IconAssets().iconClose),
              )
            ],
          )),
    );
  }
}

Widget buildActionDialog({Widget text, Function onTap, Color colorBackground}) {
  if (colorBackground == null) colorBackground = Color(0xffF2F5F7);
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 200,
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
          color: colorBackground,
          borderRadius: BorderRadius.all(Radius.circular(2))),
      child: Align(alignment: Alignment.center, child: text),
    ),
  );
}

const packageName = 'base';
