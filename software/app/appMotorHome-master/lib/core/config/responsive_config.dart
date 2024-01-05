import 'dart:math' as math;
import 'package:flutter/cupertino.dart';

class Responsive {
  Responsive(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _height = size.height;
    _width = size.width;
    _diagonal = math.sqrt(math.pow(_width, 2) + math.pow(_height, 2));
    _isPortrait = size.height > size.width;
  }

  late double _diagonal;
  late double _height;
  late double _width;
  late bool _isPortrait;

  double get diagonal => _diagonal;
  double get height => _height;
  double get width => _width;
  bool get isPortrait => _isPortrait;

  double wp(double percent) => _width * (percent / 100);
  double hp(double percent) => _height * (percent / 100);
  double dp(double percent) => _diagonal * (percent / 100);
}

extension ResponsiveExtension on BuildContext {
  double dp(double dp) => Responsive(this).dp(dp);
  double hp(double hp) => Responsive(this).hp(hp);
  double wp(double wp) => Responsive(this).wp(wp);
  double get height => Responsive(this).height;
  double get width => Responsive(this).width;
  double get diagonal => Responsive(this).diagonal;
  bool get isPortrait => Responsive(this).isPortrait;
}
