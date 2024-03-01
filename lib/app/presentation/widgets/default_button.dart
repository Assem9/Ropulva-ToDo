import 'package:flutter/material.dart';

import '../../../core/themes/colors.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    super.key,
    required this.text,
    required this.onTap
  });
  final String text;
  final Function onTap ;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(  MyColors.green ), // Set button background color
          elevation:MaterialStateProperty.all(0,),
          minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 53)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // Set button border radius
            ),
          ),
        ),
        onPressed: ()=> onTap() ,
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Colors.white
          ),
        )
    );
  }
}
