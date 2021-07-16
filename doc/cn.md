<img src="https://raw.githubusercontent.com/xyhxx/program_preview/master/logo/bezier_curve.png" />


# 介绍

通过数据计算的方式得到贝塞尔曲线的控制点，再通过 flutter 的绘图功能将点绘制成曲线。

> **为什么不使用普通的描点方式**

普通的根据元素位置进行描点的方式会留出空隙，要计算出控制点后才可以完全填充元素信息，例如下面图片，使用的点坐标相同，但是裁剪出的样式不同，我想提供的功能就是尽可能还原设计样式。而且使用插件之后只需要确认每个点的坐标即可，不用进行其他的复杂计算，代码也更简洁。

<img src="https://raw.githubusercontent.com/xyhxx/program_preview/master/proste_bezier_curve/contrast.png" style="width: 300px;" />

- 普通代码

```dart
Stack(
  children: [
    Container(
      height: 200,
      color: Colors.grey,
    ),
    ClipPath(
      clipper: NativeClipper(),
      child: Container(
        height: 200,
        color: Colors.red,
      ),
    ),
  ],
)

class NativeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, 0);
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
```

- 插件代码

```dart

Stack(
  children: [
    Container(
      height: 200,
      color: Colors.grey,
    ),
    ClipPath(
      clipper: ProsteBezierCurve(
        position: ClipPosition.bottom,
        list: [
          BezierCurveSection(
            start: Offset(0, 150),
            top: Offset(screenWidth / 2, 200),
            end: Offset(screenWidth, 150),
          ),
        ],
      ),
      child: Container(
        height: 200,
        color: Colors.red,
      ),
    ),
  ],
),

```

# 使用方法

## 二阶贝塞尔曲线

<div style="display: flex; align-items: flex-start; justify-content: space-between;">
  <img style="width: 200px;" src="https://raw.githubusercontent.com/xyhxx/program_preview/master/proste_bezier_curve/top.png" />
  <img  style="width: 200px;" src="https://raw.githubusercontent.com/xyhxx/program_preview/master/proste_bezier_curve/bottom.png" />
</div>

<a href="https://github.com/xyhxx/program_preview/tree/master/proste_bezier_curve" target="_blank">更多预览图</a>

### 示例

```dart
  ClipPath(
    clipper: ProsteBezierCurve(
      position: ClipPosition.top,
      list: [
        BezierCurveSection(
          start: Offset(screenWidth, 0),
          top: Offset(screenWidth / 2, 30),
          end: Offset(0, 0),
        ),
      ],
    ),
    child: Container(
      color: Colors.red,
      height: 150,
    ),
  )

  
  /// 波浪线
  ClipPath(
    clipper: ProsteBezierCurve(
      position: ClipPosition.bottom,
      list: [
        BezierCurveSection(
          start: Offset(0, 125),
          top: Offset(screenWidth / 4, 150),
          end: Offset(screenWidth / 2, 125),
        ),
        BezierCurveSection(
          start: Offset(screenWidth / 2, 125),
          top: Offset(screenWidth / 4 * 3, 100),
          end: Offset(screenWidth, 150),
        ),
      ],
    ),
    child: Container(
      height: 150,
      color: Colors.red,
    ),
  )
```

### class

+ `ProsteBezierCurve` 用于绘制并返回裁剪路径

|   参数   | 类型   | 默认值   | 介绍 |
| :------: | :---: | :---: | ---- |
|   list   | List\<BezierCurveSection> | |用于绘制贝塞尔曲线，可以传入多个 |
|  reclip  | bool| true | 是否允许重绘元素  |
| position |ClipPosition | ClipPosition.left | 用于确定曲线绘制位置             |

```dart
  ClipPath(
    clipper: ProsteBezierCurve(
      position: ClipPosition.top,
      reclip: false,
      list: [
        ...
      ],
    ),
    child: ...,
  ),
```
+ `BezierCurveSection` 用于绘制曲线的片段

| 参数 | 类型 | 默认值 | 介绍 |
| :------: | :---: | :---: | ---- |
| start | Offset | | 贝塞尔曲线起点 |
| top | Offset | | 贝塞尔曲线顶点 |
| end | Offset | | 贝塞尔曲线终点 |
| proportion | double | 1/2 | 贝塞尔曲线顶点所在位置比例,基本不需要修改 |

```dart

  ClipPath(
    clipper: ProsteBezierCurve(
      position: ClipPosition.top,
      reclip: false,
      list: [
        BezierCurveSection(
          proportion: 1 / 3,
          start: Offset(..,..),
          top: Offset(..,..),
          end: Offset(..,..),
        ),
      ],
    ),
    child: ...,
  )

```

+ `BezierCurveDots` 贝塞尔曲线控制点坐标

| 参数 | 类型 | 默认值 | 介绍 |
| :------: | :---: | :---: | ---- |
| x1 | double | | 第一个点的x坐标 |
| y1 | double | | 第一个点的y坐标 |
| x2 | double | | 第二个点的x坐标 |
| y2 | double | | 第二个点的y坐标 |

### ProsteBezierCurve 的静态方法
+ `BezierCurveDots calcCurveDots(BezierCurveSection param)` 获得计算后的控制点坐标，通常用于通过计算方法得到数据后自己绘制路径，例如多条边绘制曲线或者将曲线与其他绘制规则结合

``` dart

ClipPath(
  clipper: CustomSelfClipper1(),
  child: Container(
    height: 150,
    color: Colors.red,
  ),
)

class CustomSelfClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    BezierCurveSection section1 = BezierCurveSection(
      start: Offset(0, 30),
      top: Offset(10, 45),
      end: Offset(0, 60),
    );
    BezierCurveSection section2 = BezierCurveSection(
      start: Offset(size.width, size.height - 90),
      top: Offset(size.width - 10, size.height - 105),
      end: Offset(size.width, size.height - 120),
    );
    BezierCurveDots dot1 = ProsteBezierCurve.calcCurveDots(section1);
    BezierCurveDots dot2 = ProsteBezierCurve.calcCurveDots(section2);

    List<double> dot1List = dot1.getList(); // 将获取结果以List<double>形式返回
    Map<String, double> dot2Map = dot1.getMap(); // 将获取结果以Map<String, double>形式返回

    print(dot1List); // [20.0, 45.0, 0.0, 60.0]
    print(dot2Map); // {x1: 20.0, y1: 45.0, x2: 0.0, y2: 60.0}

    path.lineTo(0, 0);
    path.lineTo(0, 30);
    path.quadraticBezierTo(dot1.x1, dot1.y1, dot1.x2, dot1.y2);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height - 90);
    path.quadraticBezierTo(dot2.x1, dot2.y1, dot2.x2, dot2.y2);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

/// 这个方法可以拼接出三阶贝塞尔曲线，不推荐，可以使用下面的ProsteThirdOrderBezierCurve
class CustomSelfClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    BezierCurveSection section1 = BezierCurveSection(
      start: Offset(0, size.height),
      top: Offset(30, size.height - 50),
      end: Offset(80, size.height - 70),
    );
    BezierCurveSection section2 = BezierCurveSection(
      start: Offset(size.width - 100, size.height - 70),
      top: Offset(size.width - 30, size.height - 95),
      end: Offset(size.width, size.height - 160),
    );
    BezierCurveDots dot1 = ProsteBezierCurve.calcCurveDots(section1);
    BezierCurveDots dot2 = ProsteBezierCurve.calcCurveDots(section2);

    path.lineTo(0, 0);
    path.lineTo(0, size.height);
    path.quadraticBezierTo(dot1.x1, dot1.y1, dot1.x2, dot1.y2);
    path.lineTo(size.width - 100, size.height - 70);
    path.quadraticBezierTo(dot2.x1, dot2.y1, dot2.x2, dot2.y2);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

```

##  三阶贝塞尔曲线

<div style="display: flex; align-items: flex-start; justify-content: space-between;">
  <img style="width: 200px;" src="https://raw.githubusercontent.com/xyhxx/program_preview/master/proste_bezier_curve/third3.png" />
  <img  style="width: 200px;" src="https://raw.githubusercontent.com/xyhxx/program_preview/master/proste_bezier_curve/third2.png" />
</div>

<a href="https://github.com/xyhxx/program_preview/tree/master/proste_bezier_curve" target="_blank">更多预览图</a>

### 示例

``` dart

  ClipPath(
    clipper: ProsteThirdOrderBezierCurve(
      position: ClipPosition.bottom,
      list: [
        ThirdOrderBezierCurveSection(
          p1: Offset(0, 100),
          p2: Offset(0, 200),
          p3: Offset(screenWidth, 100),
          p4: Offset(screenWidth, 200),
        ),
      ],
    ),
    child: Container(
      height: 200,
      color: Colors.red,
    ),
  )

```

### class

+ `ProsteThirdOrderBezierCurve` 用于绘制并返回三阶贝塞尔曲线的裁剪路径

|   参数   | 类型   | 默认值   | 介绍 |
| :------: | :---: | :---: | ---- |
|   list   | List\<ThirdOrderBezierCurveSection> | |用于绘制贝塞尔曲线，可以传入多个 |
|  reclip  | bool| true | 是否允许重绘元素  |
| position |ClipPosition | ClipPosition.left | 用于确定曲线绘制位置             |

```dart
ClipPath(
  clipper: ProsteThirdOrderBezierCurve(
    position: ClipPosition.bottom,
    list: [
      ...
    ],
  ),
  child: ...,
)
```
+ `ThirdOrderBezierCurveSection` 用于绘制三阶贝塞尔曲线的片段

|   参数   | 类型   | 默认值   | 介绍 |
| :------: | :---: | :---: | ---- |
| p1 | Offset | | 第一个点的坐标 |
| p2 | Offset | | 第二个点的坐标 |
| p3 | Offset | | 第三个点的坐标 |
| p4 | Offset | | 第四个点的坐标 |
| smooth | double | .5 | 平滑度 0~1数值越大越平直 数值越小弧线越大，当绘制距离较短出现锯齿时尝试增加此数值 |

``` dart
ClipPath(
  clipper: ProsteThirdOrderBezierCurve(
    position: ClipPosition.bottom,
    list: [
      ThirdOrderBezierCurveSection(
        smooth: .7,
        p1: Offset(0, 100),
        p2: Offset(0, 200),
        p3: Offset(screenWidth, 100),
        p4: Offset(screenWidth, 200),
      ),
    ],
  ),
  child: Container(
    height: 200,
    color: Colors.red,
  ),
)

/// 尖塔形状
ClipPath(
  clipper: ProsteThirdOrderBezierCurve(
    position: ClipPosition.top,
    list: [
      ThirdOrderBezierCurveSection(
        p1: Offset(screenWidth, 0),
        p2: Offset(screenWidth, 100),
        p4: Offset(screenWidth / 2, 100),
        p3: Offset(screenWidth / 2, 0),
      ),
      ThirdOrderBezierCurveSection(
        p1: Offset(screenWidth / 2, 100),
        p2: Offset(screenWidth / 2, 0),
        p3: Offset(0, 100),
        p4: Offset(0, 0),
      ),
    ],
  ),
  child: Container(
    height: 200,
    color: Colors.teal,
  ),
)
```

四个点的位置坐标可以参考下图，起始和结束点分别为p1和p4，<a href="https://www.desmos.com/calculator/cahqdxeshd?lang=zh-CN" target="_blank">图片示例网址。</a>你可以理解为四个点形成了一个长方形，四个坐标为四个点的位置，曲线会在长方形内进行绘制。

<img src="https://raw.githubusercontent.com/xyhxx/program_preview/master/proste_bezier_curve/desmos.png" />

我们也可以通过三阶贝塞尔函数画出单弧线图，只需要p1和p4在同一边，但是这样会出现一开始声明的那个问题，不会紧贴底部。

<img src="https://raw.githubusercontent.com/xyhxx/program_preview/master/proste_bezier_curve/desmos4.png" />

+ ThirdOrderBezierCurveDots 三阶贝塞尔控制点坐标

| 参数 | 类型 | 默认值 | 介绍 |
| :------: | :---: | :---: | ---- |
| x1 | double | | 第一个点的x坐标 |
| y1 | double | | 第一个点的y坐标 |
| x2 | double | | 第二个点的x坐标 |
| y2 | double | | 第二个点的y坐标 |
| x3 | double | | 第三个点的x坐标 |
| y3 | double | | 第三个点的y坐标 |

### ProsteThirdOrderBezierCurve 的静态方法
+ `ThirdOrderBezierCurveDots calcCurveDots(ThirdOrderBezierCurveSection param)` 获得计算后的控制点坐标，通常用于通过计算方法得到数据后自己绘制路径，例如多条边绘制曲线或者将曲线与其他绘制规则结合

``` dart

ClipPath(
  clipper: CustomSelfClipper1(),
  child: Container(
    height: 200,
    color: Colors.teal,
  ),
)

class CustomSelfClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    ThirdOrderBezierCurveSection param = ThirdOrderBezierCurveSection(
      smooth: 0.3,
      p1: Offset(0, size.height),
      p2: Offset(0, 0),
      p3: Offset(size.width, size.height),
      p4: Offset(size.width, 0),
    );
    ThirdOrderBezierCurveDots dots = ProsteThirdOrderBezierCurve.calcCurveDots(param);

    List<double> dotsList = dots.getList(); // 以数组形式获取控制点
    Map<String, double> dotsMap = dots.getMap(); // 以Map形式获取控制点

    print(dotsList); // [71.56809408040556, 0.0, 339.8604773481659, 200.0, 411.42857142857144, 0.0]
    print(dotsMap); // {x1: 71.56809408040556, y1: 0.0, x2: 339.8604773481659, y2: 200.0, x3: 411.42857142857144, y3: 0.0}

    path.lineTo(0, 0);
    path.lineTo(0, size.height);
    path.cubicTo(dots.x1, dots.y1, dots.x2, dots.y2, dots.x3, dots.y3);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

```

**如果有什么问题欢迎提交到<a href="https://github.com/xyhxx/proste_bezier_curve/issues" target="_blank">issues</a>,我会在看到的第一时间进行处理，感谢！**