import 'package:flutter/material.dart';

/// 贝塞尔曲线的各个点
class BezierCurveSection {
  /// 贝塞尔曲线起点
  Offset start;

  /// 贝塞尔曲线顶部
  Offset top;

  /// 贝塞尔曲线终点
  Offset end;

  /// 贝塞尔曲线顶点所在比例
  double proportion;

  BezierCurveSection({
    @required this.start,
    @required this.top,
    @required this.end,
    this.proportion = 1 / 2,
  })  : assert(proportion > 0),
        assert(proportion < 1);
}

/// 三阶贝塞尔曲线的点集合
class ThirdOrderBezierCurveSection {
  /// 起始点
  Offset p1;

  /// 第二点
  Offset p2;

  /// 第三点
  Offset p3;

  /// 第四点
  Offset p4;

  /// 平滑度 0~1数值越大越平直 数值越小弧线越大
  double smooth;

  ThirdOrderBezierCurveSection({
    @required this.p1,
    @required this.p2,
    @required this.p3,
    @required this.p4,
    this.smooth = .5,
  })  : assert(smooth >= 0),
        assert(smooth <= 1);
}

/// 贝塞尔曲线的画线位置
class BezierCurveDots {
  /// 第一个点的x坐标
  double x1;

  /// 第一个点的y坐标
  double y1;

  /// 第二个点的x坐标
  double x2;

  /// 第二个点的y坐标
  double y2;
  BezierCurveDots(
    this.x1,
    this.y1,
    this.x2,
    this.y2,
  );

  /// 返回数组对象
  List<double> getList() {
    return [x1, y1, x2, y2];
  }

  Map<String, double> getMap() {
    return {
      'x1': x1,
      'y1': y1,
      'x2': x2,
      'y2': y2,
    };
  }
}

/// 三阶贝塞尔的画线位置
class ThirdOrderBezierCurveDots {
  /// 第一个点的x坐标
  double x1;

  /// 第一个点的y坐标
  double y1;

  /// 第二个点的x坐标
  double x2;

  /// 第二个点的y坐标
  double y2;

  /// 第三个点的x坐标
  double x3;

  /// 第三个点的y坐标
  double y3;

  ThirdOrderBezierCurveDots(
    this.x1,
    this.y1,
    this.x2,
    this.y2,
    this.x3,
    this.y3,
  );

  List<double> getList() {
    return [x1, y1, x2, y2, x3, y3];
  }

  Map<String, double> getMap() {
    return {
      'x1': x1,
      'y1': y1,
      'x2': x2,
      'y2': y2,
      'x3': x3,
      'y3': y3,
    };
  }
}
