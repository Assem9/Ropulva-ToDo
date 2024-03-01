import 'dart:io';

import 'package:hive/hive.dart';

import '../models/task_model.dart';
import 'package:path_provider/path_provider.dart';

class LocalDataSource{
  Future<String> _initializeAppDirectory()async{
    late String installationDirectory ;
    if(Platform.isWindows){
    installationDirectory =
      Platform.environment.containsKey('FLUTTER_ROOT')
          ? Directory.current.path
          : Platform.script.toFilePath().replaceAll(
        RegExp(r'[/\\][^/\\]+(\.dart)?$'),
        '',
      );
    }
    else{
      var dir =  await getApplicationDocumentsDirectory();
      installationDirectory = dir.path ;
    }

    return installationDirectory  ;
  }
  Future<Box<TaskModel>> _openOfflineTasksBox()async {
    String dir = await _initializeAppDirectory() ;
    return await Hive.openBox(
        'offlineTasksBox',
        path: '$dir/tasks/'
    );
  }

  Future<List<TaskModel>> getAllTasks()async{
    final taskBox = await _openOfflineTasksBox();
    List<TaskModel> tasks = taskBox.values.toList();
    print('local tasks ${tasks.length}');
    return tasks;

  }

  Future<void> clearCache()async{
    final taskBox = await _openOfflineTasksBox();
    taskBox.clear();
  }

  Future<void> saveTask(TaskModel task)async{
    final taskBox = await _openOfflineTasksBox();
    await taskBox.put(task.id, task);
    await taskBox.close();
  }

  Future<void> finishTask(TaskModel task)async{
    final taskBox = await _openOfflineTasksBox();
    await taskBox.put(
        task.id,
        TaskModel(id: task.id, title: task.title, dueDate: task.dueDate,isDone: true)
    );
    //throw(UnimplementedError('Custome Error'));
    await taskBox.close();
  }



  //  Future<Box<TaskModel>> _openAllTasksBox()async {
//     return await Hive.openBox(
//         'allTasksBox',
//         path: 'tasks/'
//     );
//   }
}