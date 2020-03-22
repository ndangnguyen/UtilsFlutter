import 'package:base/base/base.dart';
import 'package:base/dialog/be_dialog.dart';
import 'package:base/utils/be_text.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

/// Cách dùng
/// with ErrorWare
/// ex: class _HelpCenterScreenState extends BaseState<HelpCenterScreen> with ErrorWare
///
/// override 2 phương thức errorStream và dialogBuilder
///
/// ex: Observable<String> get errorStream => _bloc.errorStream;
/// Trong bloc của screen, nếu có bất kì lỗi gì sảy ra thì bắn 1 text (nội dung error) vào stream errorStream
///
/// dialogBuilder: dùng để nếu như muốn custom lại dialog. Truyền 1 method vào phương thức get này.
///
/// ex:   Function() get dialogBuilder => showDialogCall;
///
///  void showDialogCall() {
///    showBeDialog(
///      context: context,
///      isHorizontal: true,
///      isHideClose: true,
///      icon: Container(
///        margin: EdgeInsets.only(left: 24, right: 24, top: 24),
///        decoration:
///           BoxDecoration(shape: BoxShape.circle, color: Color(0xffCAE4FF)),
///       child: Padding(
///         padding: const EdgeInsets.all(8.0),
///         child: Icon(
///            Icons.phone,
///            size: 32,
///            color: Color(0xff1366E9),
///          ),
///        ),
///      ),
///      listAction: [
///        Expanded(
///          child: buildActionDialog(
///              text: BeText(
///                "Huỷ bỏ",
///                fontWeight: FontWeight.bold,
///              ),
///              onTap: () {
///                print('_MyHomePageState.build');
///                Navigator.pop(context);
///              }),
///        ),
///        Container(
///          width: 12,
///        ),
///        Expanded(
///          child: buildActionDialog(
///              text: BeText(
///                "Đồng ý",
///                fontWeight: FontWeight.bold,
///              ),
///              colorBackground: Color(0xffFFBB00),
///              onTap: () {
///                launch("tel://1900232345");
///                Navigator.pop(context);
///              }),
///        ),
///      ],
///      title: 'Hỗ trợ qua điện thoại',
///      desc: 'Bạn muốn gọi tới số 1900 232345 không?',
///    );
///  }

mixin ErrorWare<T extends StatefulWidget> on BaseState<T> {
  Function() get dialogBuilder;

  Observable<String> get errorStream;

  @override
  void initState() {
    print('ErrorWare.initState');
    errorStream.listen((data) {
      if (dialogBuilder == null) {
        showDialog(data);
      } else
        dialogBuilder();
    });
    super.initState();
  }

  void showDialog(String desc) {
    showBeDialog(
      context: context,
      isHorizontal: true,
      isHideClose: true,
      listAction: [
        Expanded(
          child: buildActionDialog(
              text: BeText(
                "OK",
                fontWeight: FontWeight.bold,
              ),
              onTap: () {
                Navigator.pop(context);
              }),
        ),
      ],
      title: BeTitle("Lỗi"),
      desc: BeText(desc),
    );
  }
}
