import 'package:get_it/get_it.dart';
import 'package:ropulva_task/app/controllers/tasks_bloc.dart';
import 'package:ropulva_task/app/data/data_sources/remote_data_source.dart';
import 'package:ropulva_task/app/data/repos/task_Repo.dart';

import '../../app/data/data_sources/local_data_source.dart';

final getIt = GetIt.instance;

class ServiceLocator{

  static void initApp(){
    getIt.registerLazySingleton<RemoteDataSource>(() => RemoteDataSource());
    getIt.registerLazySingleton<LocalDataSource>(() => LocalDataSource());
    getIt.registerLazySingleton<TaskRepository>(() => TaskRepository(getIt(),getIt()));
    getIt.registerLazySingleton<TasksBloc>(() => TasksBloc(getIt()));
  }

}