import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:ropulva_task/app/data/data_sources/remote_data_source.dart';
import 'package:ropulva_task/app/data/models/task_model.dart';
import '../../../core/error/failure.dart';
import '../data_sources/local_data_source.dart';

class TaskRepository{
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;
  TaskRepository(this._remoteDataSource, this._localDataSource);

  Future<Either<Failure, List<TaskModel>>> getAllTasks() async{
    try{
      print('getAllTasks');
      List<TaskModel> cachedTasks = await _localDataSource.getAllTasks();
      List<TaskModel> tasks;
      if(cachedTasks.isNotEmpty){
        tasks = await _fetchCachedDateWithBackend(cachedTasks);
      }
      else{
        tasks = await _remoteDataSource.getAllTasks([]);
      }
      return Right(tasks);
    }on FirebaseException catch(e){
      return Left(ServerFailure(message:e.message!,code: e.code));
    }catch (e){
      return Left(InternalFailure(message: e.toString(), code: 'Dev-Issues'));
    }
  }


  Future<  List<TaskModel>> _fetchCachedDateWithBackend(List<TaskModel> cachedTasks )async{
    List<TaskModel> tasks = [];
    print('cachedTasks ${cachedTasks.length}');
    for(var task in cachedTasks){
      print('adding ${task.title} from cache');
      await _remoteDataSource.addNewTask(task);
    }
    await _localDataSource.clearCache();
    tasks = await _remoteDataSource.getAllTasks(cachedTasks.map((e) => e.id).toList());
    tasks.addAll(cachedTasks);
    return tasks;
  }

  Future<Either<Failure, dynamic>> addNewTask({
    required TaskModel taskModel
  }) async{
    try{
      InternetStatus status = await InternetConnection().internetStatus   ;
      if(status == InternetStatus.connected){
        print('Adding task in backend');
        await _remoteDataSource.addNewTask(taskModel);
      }
      else{
        print('Adding task in local db');
        await _localDataSource.saveTask(taskModel);
      }
      return const Right('Done');
    }on FirebaseException catch(e){
      return Left(ServerFailure(message:e.message!,code: e.code));
    }catch (e){
      return Left(InternalFailure(message: e.toString(), code: 'Dev-Issues'));
    }
  }


  Future<Either<Failure, dynamic>> finishTask({
    required TaskModel task
  }) async{
    try{
      InternetStatus status = await InternetConnection().internetStatus   ;
      if(status == InternetStatus.connected){
        await _remoteDataSource.updateTaskToFinished(task.id);
      }
      else{
        print('finishTask task in local db');
        await _localDataSource.finishTask(task);
      }

      return const Right('Done');
    }on FirebaseException catch(e){
      return Left(ServerFailure(message:e.message!,code: e.code));
    }catch (e){
      return Left(InternalFailure(message: e.toString(), code: 'Not-Server-Issues'));
    }
  }

}