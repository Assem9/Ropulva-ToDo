import 'package:flutter/material.dart';
import 'package:ropulva_task/app/controllers/tasks_bloc.dart';
import 'package:ropulva_task/app/controllers/tasks_event.dart';
import 'package:ropulva_task/app/controllers/tasks_state.dart';

import '../../../core/themes/colors.dart';

class DefaultChip extends StatelessWidget {
  const DefaultChip({
    super.key,
    required this.filter,
    required this.onTap, required this.isSelected
  });
  final TaskFilter filter;
  final Function onTap ;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            isSelected
              ? MyColors.green
              : MyColors.lightGreen,
          ), // Set button background color
            elevation:MaterialStateProperty.all(0,),
          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 3 ,horizontal: 10),),
          minimumSize: MaterialStateProperty.all<Size>(const Size(49, 32)),
            maximumSize: MaterialStateProperty.all<Size>(const Size(double.infinity, double.infinity)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // Set button border radius
            ),
          ),
        ),
        onPressed: (){
          TasksBloc.get(context).add(ChangeTaskFilterEvent(filter));

        },
        child: Text(
          filter.toText(),
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: isSelected?  Colors.white :MyColors.green
          ),
        )
    );
    // return InkWell(
    //   onTap: (){
    //     widget.onTap();
    //     setState(() {
    //       _isSelected = !_isSelected ;
    //     });
    //     print('selectec $_isSelected');
    //   },
    //   child: Container(
    //     decoration: BoxDecoration(
    //         color:_isSelected
    //             ? MyColors.green
    //             : MyColors.lightGreen,
    //         borderRadius: BorderRadius.circular(10)
    //     ),
    //     constraints: BoxConstraints(
    //         minWidth: 57
    //     ),
    //     alignment: AlignmentDirectional.center,
    //     padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
    //     margin: const EdgeInsets.only(right: 5,bottom: 9),
    //     child: Text(
    //       widget.title,
    //       style: Theme.of(context).textTheme.bodyMedium!.copyWith(
    //           color: _isSelected?  Colors.white :MyColors.green
    //       ),
    //     ),
    //   ),
    // );
  }
}