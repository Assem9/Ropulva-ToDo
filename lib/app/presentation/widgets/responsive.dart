import 'package:flutter/material.dart';

class MyResponsive extends StatelessWidget {
  final Widget mobile;
  final Widget? mobileLarge;
  final Widget? tablet;
  final Widget? tabletLarge;
  final Widget? desktopSmall;
  final Widget desktop;

  const MyResponsive({
    super.key,
    required this.mobile,
    this.tablet,
    this.tabletLarge,
    this.desktopSmall,
    required this.desktop,
    this.mobileLarge,
  });

  Size size(BuildContext context) => MediaQuery.of(context).size;

  double width(BuildContext context) => size(context).width;

  double height(BuildContext context) => size(context).height;
  static const double _mobWidth = 600;
  static const double _mobLargeWidth = 750;
  static const double _tabWidth = 850;
  static const double _deskSmallWidth = 1000;
  static const double _deskWidth = 1250;

  static T getPlatSiz_D_Ds_Tl_T_Ml_M<T>(BuildContext context,
      T d,
      T ds,
      T tl,
      T t, T ml, T m) {
    if (isMobileLarge(context)) return ml;
    if (isTablet(context)) return t;
    if (isTabletLarge(context)) return tl;
    if (isSmallDesktop(context)) return ds;
    if (isDesktop(context)) return d;
    return m;
  }

  static double getMediaWidth_D_Ds_Tl_T_Ml_M(BuildContext context,
      double d,
      double ds,
      double tl,
      double t, double ml, double m,) {
    if (isMobileLarge(context)&&ml<=1) return MediaQuery.of(context).size.width*ml;
    if (isTablet(context)&&t<=1) return MediaQuery.of(context).size.width*t;
    if (isTabletLarge(context)&&tl<=1) return MediaQuery.of(context).size.width*tl;
    if (isDesktop(context)&&d<=1) return MediaQuery.of(context).size.width*d;
    if (isSmallDesktop(context)&&ds<=1) return MediaQuery.of(context).size.width*ds;
    if (isMobile(context)&&m<=1) return MediaQuery.of(context).size.width*m;
    else{
      throw("value must < or = 1");
    }
  }

  static double getMediaHeight_D_Ds_Tl_T_Ml_M(BuildContext context,
      double d,
      double ds,
      double tl,
      double t, double ml, double m,) {
    if (isMobileLarge(context)&&ml<=1) return MediaQuery.of(context).size.height*ml;
    if (isTablet(context)&&t<=1) return MediaQuery.of(context).size.height*t;
    if (isTabletLarge(context)&&tl<=1) return MediaQuery.of(context).size.height*tl;
    if (isDesktop(context)&&d<=1) return MediaQuery.of(context).size.height*d;
    if (isSmallDesktop(context)&&d<=1) return MediaQuery.of(context).size.height*ds;
    if (isMobile(context)&&m<=1) return MediaQuery.of(context).size.height*m;
    else{
      throw("value must < or = 1");
    }
  }

  static double getMediaAspectRatio_D_Ds_Tl_T_Ml_M(BuildContext context,
      double d,
      double ds,
      double tl,
      double t, double ml, double m,) {
    if (isMobileLarge(context)) return MediaQuery.of(context).size.aspectRatio*ml;
    if (isTablet(context)) return MediaQuery.of(context).size.aspectRatio*t;
    if (isTabletLarge(context)) return MediaQuery.of(context).size.aspectRatio*tl;
    if (isDesktop(context)) return MediaQuery.of(context).size.aspectRatio*d;
    if (isSmallDesktop(context)) return MediaQuery.of(context).size.aspectRatio*ds;
     return MediaQuery.of(context).size.aspectRatio*m;

  }

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width <= _mobWidth;

  static bool isMobileLarge(BuildContext context) =>
      MediaQuery.of(context).size.width <= _mobLargeWidth&&
      MediaQuery.of(context).size.width > _mobWidth
  ;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width <= _tabWidth&&
      MediaQuery.of(context).size.width > _mobLargeWidth
  ;

  static bool isTabletLarge(BuildContext context) =>
      MediaQuery.of(context).size.width < _deskSmallWidth &&
      MediaQuery.of(context).size.width > _tabWidth;

  static bool isSmallDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= _deskSmallWidth&&
      MediaQuery.of(context).size.width < _deskWidth;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= _deskWidth;

  @override
  Widget build(BuildContext context) {
    if (width(context) >= _deskWidth) {
      return desktop;
    }else if (width(context) >= _deskSmallWidth&&width(context)<_deskWidth && desktopSmall != null) {
      return desktopSmall!;
    }
    else if (width(context) >= _tabWidth && tabletLarge != null) {
      return tabletLarge!;
    } else if (width(context) >= _mobLargeWidth && tablet != null) {
      return tablet!;
    } else if (width(context) >= _mobWidth && mobileLarge != null) {
      return mobileLarge!;
    } else {
      return mobile;
    }
  }

  static Widget? vewIfWidthGreatThat({
    required BuildContext context,
    required double width,
    required Widget child,
    Widget? elseChild,
  }) {
    return MediaQuery.of(context).size.width>=width?child:elseChild;

  }


}
