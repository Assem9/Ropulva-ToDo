import 'package:flutter/material.dart';
import 'package:ropulva_task/core/themes/colors.dart';

class DefaultLoader extends StatelessWidget {
  const DefaultLoader({super.key, this.alignment});
  final AlignmentDirectional? alignment;
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Align(
        alignment: alignment?? AlignmentDirectional.bottomCenter,
        child: const CircleAvatar(
            backgroundColor: MyColors.cardColor,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(color: MyColors.green,strokeWidth: 4,),
            )),
      ),
    );
  }
}