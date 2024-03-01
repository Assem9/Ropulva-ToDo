import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ropulva_task/app/controllers/tasks_event.dart';
import 'package:ropulva_task/app/controllers/tasks_state.dart';
import 'package:ropulva_task/app/data/models/task_model.dart';

import '../data/repos/task_Repo.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TaskRepository _taskRepository;
  static TasksBloc get(context)=> BlocProvider.of(context);
  TasksBloc(this._taskRepository) : super(const TasksState()) {

    on<LoadTasksEvent>(_getAllTasks);
    on<FinishTaskEvent>(_finishTask);
    on<ChangeTaskFilterEvent>(_changeCurrentTaskFilter);
    on<AddNewTaskEvent>(_addNewTask);
    on<ChangeShowDragTargetValueEvent>(_dragTask);

  }

  List<TaskModel> _allTasks = [];
  void _getAllTasks(LoadTasksEvent event,Emitter<TasksState> emit)async{
    emit(state.copyWith(getTasksRequest: RequestState.loading));
    final result = await _taskRepository.getAllTasks();
    result.fold((failure){
      emit(state.copyWith(getTasksRequest: RequestState.error,error: failure.message));
    }, (loadedTasks){
      _allTasks = loadedTasks ;
      emit(state.copyWith(
        getTasksRequest: RequestState.success,
        tasks: _filterTasks(state.currentFilter),
      ));
    });

  }

  void _finishTask(FinishTaskEvent event,Emitter<TasksState> emit)async{
    emit(state.copyWith(finishTaskRequest: RequestState.loading,finishingTaskId: event.task.id));
    final result = await _taskRepository.finishTask(task: event.task );
    result.fold((failure){
      emit(state.copyWith(finishTaskRequest: RequestState.error,error: failure.message));
    }, (success){
      event.task.isDone = true ;
      emit(state.copyWith(
          finishTaskRequest: RequestState.success,
          tasks: _filterTasks(state.currentFilter)
      )
      );
    });
  }

  void _addNewTask(AddNewTaskEvent event,Emitter<TasksState> emit)async{
    emit(state.copyWith(addNewTaskRequest: RequestState.loading));
    TaskModel newTask = TaskModel(
        id: 'task${DateTime.now().toIso8601String()}',
        title: event.title,
        dueDate: event.dueDate
    );
    final result = await _taskRepository.addNewTask(taskModel: newTask);
    result.fold((failure){
      emit(state.copyWith(addNewTaskRequest: RequestState.error,error: failure.message));
    }, (success){
      _allTasks.add(newTask);
      emit(state.copyWith(
        addNewTaskRequest: RequestState.success,
        tasks: _filterTasks(state.currentFilter)
      ));
    });
  }

  List<TaskModel> _filterTasks(TaskFilter filter){
    //List<TaskModel> tasks = _allTasks;
    switch(filter){
      case TaskFilter.all:
        return _allTasks;
      case TaskFilter.done:
        return _allTasks.where((task) => task.isDone).toList();
      case TaskFilter.notDone:
        return _allTasks.where((task) => !task.isDone).toList();

    }
  }

  FutureOr<void> _changeCurrentTaskFilter(ChangeTaskFilterEvent event, Emitter<TasksState> emit) {
    emit(
        state.copyWith(
            currentFilter: event.filter,
            tasks: _filterTasks(event.filter)
        )
    );
  }

  void _dragTask(ChangeShowDragTargetValueEvent event, Emitter<TasksState> emit){
    emit(state.copyWith(showDragTarget: event.value));
  }

}
