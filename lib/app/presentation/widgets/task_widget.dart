import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:ropulva_task/app/controllers/tasks_bloc.dart';
import 'package:ropulva_task/app/controllers/tasks_event.dart';
import 'package:ropulva_task/app/controllers/tasks_state.dart';
import 'package:ropulva_task/app/data/models/task_model.dart';
import 'package:ropulva_task/app/presentation/widgets/default_loader.dart';
import 'package:ropulva_task/core/services/service_locator.dart';
import 'package:ropulva_task/core/themes/colors.dart';

class TaskWidget extends StatelessWidget {
  const TaskWidget({super.key, required this.task});
  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: task.isDone 
          ? _buildTaskContent(context)
          : Platform.isWindows 
          ? _buildDraggableTaskWidget(context)
          : _buildOnLongPressDraggableTaskWidget(context),
    );
  }

  Widget _buildOnLongPressDraggableTaskWidget(BuildContext context)=> LongPressDraggable<TaskModel>(
    data: task,
    onDragStarted:(){
      TasksBloc.get(context).add(ChangeShowDragTargetValueEvent(true));
    },
    onDragEnd: (details){
      TasksBloc.get(context).add(ChangeShowDragTargetValueEvent(false));
    },
    feedback: _buildTaskContent(context),
    childWhenDragging: Container(),
    child: _buildTaskContent(context,  ), // Empty container when dragging
  );

  Widget _buildDraggableTaskWidget(BuildContext context)=> Draggable<TaskModel>(
    data: task,
    onDragStarted:(){
      TasksBloc.get(context).add(ChangeShowDragTargetValueEvent(true));
    },
    onDragEnd: (details){
      TasksBloc.get(context).add(ChangeShowDragTargetValueEvent(false));
    },
    feedback: _buildTaskContent(context),
    childWhenDragging: Container(),
    child: _buildTaskContent(context,  ), // Empty container when dragging
  );
  
  Widget _buildTaskContent(BuildContext context,  ) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 15),
      color: MyColors.cardColor,
      surfaceTintColor: MyColors.cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  task.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Due Date: ${DateFormat('E. d/M/yyyy').format(task.dueDate)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            _buildTaskFinishingWidget( ),
            // task.isDone
            //     ? SvgPicture.asset('assets/svgs/done.svg')
            //     : SvgPicture.asset('assets/svgs/not_done.svg'),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskFinishingWidget( ) {
    return BlocProvider.value(
      value: getIt<TasksBloc>(),
      child: BlocBuilder<TasksBloc,TasksState>(
          buildWhen: (previous,current)=> previous.finishTaskRequest != current.finishTaskRequest
          &&  current.finishingTaskId == task.id,
          builder: (context,state){
            print('state ${state.finishTaskRequest} - ${state.finishingTaskId}');
            if(state.finishTaskRequest == RequestState.loading){
              return const DefaultLoader();
            }
            return task.isDone
                ? SvgPicture.asset('assets/svgs/done.svg')
                : SvgPicture.asset('assets/svgs/not_done.svg') ;
      }
      ),
    );
  }
}


// constraints: const BoxConstraints(
//   minWidth: 300,   // Minimum width
//   maxWidth: 323,   // Maximum width
// ),
// margin: const EdgeInsets.only(bottom: 15),
// padding: const EdgeInsets.symmetric(vertical: 17,horizontal: 18),
// decoration: BoxDecoration(
//   color:  MyColors.cardColor,
//   borderRadius: BorderRadius.circular(10),
//     boxShadow: [
//       BoxShadow(
//           color: Colors.grey,
//           offset: Offset(0, 0.75),
//           blurRadius: 5,
//           spreadRadius: 2
//       ),
//       BoxShadow(
//           color: Colors.white,
//           offset: Offset(-0.75,-2),
//           blurRadius: 0,
//         spreadRadius: 2
//       ),
//     ]
// ),

// Card(
//       elevation: 4,
//       margin: const EdgeInsets.only(bottom: 15),
//       color:  MyColors.cardColor,
//       surfaceTintColor:  MyColors.cardColor,
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: 20,horizontal: 18),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   task.title,
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//                 Text(
//                   'Due Date: ${DateFormat('E. d/M/yyyy').format(task.dueDate)}',
//                   style: Theme.of(context).textTheme.bodyMedium,
//                 ),
//               ],
//             ),
//             task.isDone
//                 ? SvgPicture.asset( 'assets/svgs/done.svg', )
//                 : SvgPicture.asset(  'assets/svgs/not_done.svg', )
//           ],
//         ),
//       ),
//     )