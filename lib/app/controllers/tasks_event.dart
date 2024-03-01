
import 'package:ropulva_task/app/controllers/tasks_state.dart';
import 'package:ropulva_task/app/data/models/task_model.dart';

abstract class TasksEvent {}

class LoadTasksEvent extends TasksEvent{}

class FinishTaskEvent extends TasksEvent{
  final TaskModel task ;
  FinishTaskEvent(this.task);
}

class AddNewTaskEvent extends TasksEvent{
  final String title ;
  final DateTime dueDate;

  AddNewTaskEvent({required this.title, required this.dueDate});
}

class ChangeTaskFilterEvent extends TasksEvent{
  final TaskFilter filter ;
  ChangeTaskFilterEvent(this.filter);
}

class ChangeShowDragTargetValueEvent extends TasksEvent{
  final bool value ;

  ChangeShowDragTargetValueEvent(this.value);
}