import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ropulva_task/core/themes/colors.dart';
import 'package:lottie/lottie.dart';
enum ToastState{
  success,
  error,
  warning,
}

class FloatingToast extends StatelessWidget {
  final String message;
  final Color color;
  final ToastState? toastState;
  final Widget? widget;
  const FloatingToast({
    super.key,
    required this.message,
    required this.color,
    this.widget,
    this.toastState ,
  });

  Color setColorDependingOnState(context){
    switch(toastState){
      case null:
        return color;
      case ToastState.success:
        return MyColors.green;
      case ToastState.error:
        return Theme.of(context).colorScheme.error.withOpacity(0.9);
      case ToastState.warning:
        return Theme.of(context).colorScheme.error.withOpacity(0.7);
    }

  }


  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: setColorDependingOnState(context),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget??const SizedBox(),
              const SizedBox(width: 10,),
              Text(message,style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),),

            ],
          )
      ),
    );
  }
}

class MyToast {
  static OverlayEntry? _overlayEntry;
  static void show({
    required BuildContext context,
    required String message,
    ToastState? toastState,
    Color color = MyColors.green ,
    AlignmentGeometry alignment = AlignmentDirectional.bottomCenter,
    int durationInSec = 2,
    Widget? widget,
    bool showOverLottie =false,
  }) {
    _overlayEntry = OverlayEntry(
      builder: (context) => Padding(
        padding: const EdgeInsets.only(bottom: 65.0,top: 50),
        child: Align(
          alignment: alignment,
          child: !showOverLottie
              ? FloatingToast(
            toastState: toastState,
            message: message,
            color: color,
            widget:widget,
          )
              :
          Stack(
            alignment: alignment,
            children: [
              FloatingToast(
                  toastState: toastState,
                  message: message,
                  color: color,
                  widget:widget,
              ),
              Lottie.asset(
                  'assets/lotties/celebrate.json' ,
                  fit: BoxFit.contain,
                  width: MediaQuery.sizeOf(context).width * 0.8 ,
                  height: MediaQuery.sizeOf(context).width * 0.8
              )
            ],
          ),
        ),
      ),
    );

   Overlay.of(context).insert(_overlayEntry!);

    Timer(const Duration(seconds: 2), () {
      _overlayEntry!.remove();
    });
  }


}