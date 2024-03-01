
import 'package:equatable/equatable.dart';

import '../data/models/task_model.dart';

class TasksState extends Equatable {
  final RequestState getTasksRequest;
  final RequestState finishTaskRequest;
  final RequestState addNewTaskRequest;
  final List<TaskModel> tasks  ;
  final TaskFilter currentFilter ;
  final String error;
  final String finishingTaskId;
  final bool showDragTarget;

  const TasksState({
    this.error = '',
    this.finishingTaskId = '',
    this.showDragTarget = false,
    this.currentFilter = TaskFilter.all,
    this.tasks =   const [],
    this.getTasksRequest = RequestState.initial,
    this.finishTaskRequest = RequestState.initial,
    this.addNewTaskRequest = RequestState.initial,
  });
  TasksState copyWith({
    RequestState? getTasksRequest,
    RequestState? finishTaskRequest,
    List<TaskModel>? tasks,
    RequestState? addNewTaskRequest,
    TaskFilter? currentFilter,
    String? error,
    bool? showDragTarget,
    String? finishingTaskId,
  }){
    return TasksState(
        getTasksRequest: getTasksRequest?? this.getTasksRequest,
        finishTaskRequest: finishTaskRequest??this.finishTaskRequest,
        tasks: tasks??this.tasks,
        addNewTaskRequest: addNewTaskRequest?? this.addNewTaskRequest,
        currentFilter: currentFilter?? this.currentFilter,
        error: error?? this.error,
        showDragTarget: showDragTarget?? this.showDragTarget,
        finishingTaskId:finishingTaskId?? this.finishingTaskId,
    );
  }

  @override
  List<Object> get props => [
    getTasksRequest,
    finishTaskRequest,
    addNewTaskRequest,
    tasks,
    currentFilter,
    error,
    showDragTarget,
    finishingTaskId,
  ];

}

enum RequestState {
  initial,
  loading,
  success,
  error,
}

enum TaskFilter{
  all,
  notDone,
  done,
}

extension TaskFilterEX on TaskFilter{
  String toText(){
    switch(this){
      case TaskFilter.all:
        return 'All';
      case TaskFilter.notDone:
        return 'Not Done';
      case TaskFilter.done:
        return 'Done';
    }
  }
}
// List<TaskModel> dummyTasks =  [
//   TaskModel(
//       title: 'Build UI Android 1',
//       dueDate: DateTime(2024,2,21),  id: ''
//   ),
//   TaskModel(
//       title: 'Build UI Android 2 ',
//       dueDate: DateTime(2024,2,21),
//       isDone: true , id: ''
//   ),
//   TaskModel(
//       title: 'Build UI Android 3',
//       dueDate: DateTime(2024,2,21),
//       isDone: true , id: ''
//   ),
//   TaskModel(
//       title: 'Build UI Android 4',
//       dueDate: DateTime(2024,2,21),
//       isDone: false , id: ''
//   )
// ];