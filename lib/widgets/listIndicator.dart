import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_more_list/loading_more_list.dart';

Widget buildIndicator(BuildContext context, IndicatorStatus status,LoadingMoreBase listRepository) {
  //if your list is sliver list ,you should build sliver indicator for it
  //isSliver=true, when use it in sliver list
  bool isSliver = false;
  String errorText = "好像出现了问题呢？";
  Widget widget;
  switch (status) {
    case IndicatorStatus.none:
      widget = Container(height: 0.0);
      break;
    case IndicatorStatus.loadingMoreBusying:
      widget = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 5.0),
            height: 15.0,
            width: 15.0,
            child: getIndicator(context),
          ),
          const Text("正在加载...")
        ],
      );
      widget = _setbackground(context,false, widget, 35.0);
      break;
    case IndicatorStatus.fullScreenBusying:
      widget = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 0.0),
            height: 30.0,
            width: 30.0,
            child: getIndicator(context),
          ),
        ],
      );
      widget = _setbackground(context,true, widget, double.infinity);
      if (isSliver) {
      } else {
        widget = CustomScrollView(
          slivers: <Widget>[
            SliverFillRemaining(
              child: widget,
            )
          ],
        );
      }
      break;
    case IndicatorStatus.error:
      widget =  Text(
        errorText,
      );
      widget = _setbackground(context,false, widget, 35.0);

      widget = GestureDetector(
        onTap: () {
          listRepository.errorRefresh();
        },
        child: widget,
      );

      break;
    case IndicatorStatus.fullScreenError:
      widget = Text(
        errorText,
      );
      widget = _setbackground(context,true, widget, double.infinity);
      widget = GestureDetector(
        onTap: () {
          listRepository.errorRefresh();
        },
        child: widget,
      );
      if (isSliver) {
        widget = SliverFillRemaining(
          child: widget,
        );
      } else {
        widget = CustomScrollView(
          slivers: <Widget>[
            SliverFillRemaining(
              child: widget,
            )
          ],
        );
      }
      break;
    case IndicatorStatus.noMoreLoad:
      widget = const Text("没有更多了");
      widget = _setbackground(context,false, widget, 50.0);
      break;
    case IndicatorStatus.empty:
      widget = Text(
        "什么也没有找到(T_T)",style: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(46)),
      );
      widget = _setbackground(context,true, widget, double.infinity);
      widget = GestureDetector(
        onTap: () {
          listRepository.errorRefresh();
        },
        child: widget,
      );
      if (isSliver) {
      } else {
        widget = CustomScrollView(
          slivers: <Widget>[
            SliverFillRemaining(
              child: widget,
            )
          ],
        );
      }
      break;
  }
  return widget;
}

Widget _setbackground(BuildContext context,bool full, Widget widget, double height) {
  widget = Container(
      width: double.infinity,
      height: height,
      color: Colors.transparent,
      alignment: Alignment.center,
      child: widget);
  return widget;
}

Widget getIndicator(BuildContext context) {
  final platform = Theme.of(context).platform;
  return platform == TargetPlatform.iOS
      ? const CupertinoActivityIndicator(
    animating: true,
    radius: 16.0,
  )
      : CircularProgressIndicator(
    strokeWidth: 2.0,
    valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
  );
}
