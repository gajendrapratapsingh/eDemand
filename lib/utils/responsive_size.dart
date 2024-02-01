// ignore_for_file: file_names

import 'package:flutter/material.dart';

extension Sizing on double {
  double rh(final context) {
    //!Don't change [716]
    const int aspectedScreenHeight = 716;

    final size = MediaQuery.sizeOf(context);
    final  responsiveHeight = size.height * (this / aspectedScreenHeight);
    return responsiveHeight;
  }

  double rw(final context) {
    //!Don't change  [360]
    const int aspectedScreenWidth = 360;

    final Size size = MediaQuery.sizeOf(context);
    final double responsiveWidth = size.width * (this / aspectedScreenWidth);
    return responsiveWidth;
  }
}

extension SizingInt on int {
  double rh(final context) {
    //!Don't change [716]
    const int aspectedScreenHeight = 716;

    final Size size = MediaQuery.sizeOf(context);
    final double responsiveHeight = size.height * (this / aspectedScreenHeight);
    return responsiveHeight;
  }

  double rw(final context) {
    //!Don't change [360]
    const int aspectedScreenWidth = 360;

    final Size size = MediaQuery.sizeOf(context);
    final double responsiveWidth = size.width * (this / aspectedScreenWidth);
    return responsiveWidth;
  }
}
