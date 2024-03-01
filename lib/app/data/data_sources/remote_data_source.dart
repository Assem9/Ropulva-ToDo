import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ropulva_task/app/data/models/task_model.dart';

class RemoteDataSource{

  FirebaseFirestore _fireStore = FirebaseFirestore.instance ;

  Future<void> addNewTask(TaskModel task)async{
    await _fireStore.collection('tasks')
        .doc(task.id)
        .set(task.toJson());
  }

  Future<void> updateTaskToFinished(String taskId)async{
    await _fireStore.collection('tasks')
        .doc(taskId)
        .update({'isDone':true});
  }

  Future<List<TaskModel>> getAllTasks(List<String> cachedIDs)async{
    List<TaskModel> tasks = [];
    QuerySnapshot<Map<String, dynamic>> querySnapShot  ;
    if(cachedIDs.isNotEmpty){
      querySnapShot = await _fireStore.collection('tasks') .where('id',whereNotIn: cachedIDs).get();
    }
    else{
      querySnapShot = await _fireStore.collection('tasks').get();
    }

    for(var doc in querySnapShot.docs){
      tasks.add(TaskModel.fromJson(doc.data()));
    }
    return tasks;

  }

  Future<List<TaskModel>> saveCachedTasksToBackend(List<TaskModel> cachedTasks)async{
    List<TaskModel> tasks = [];
    for(var task in cachedTasks){
      await addNewTask(task);
    }
    return tasks;

  }


}