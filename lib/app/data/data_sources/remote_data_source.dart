import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ropulva_task/app/data/models/task_model.dart';
import 'package:ropulva_task/core/utils/constatnts.dart';



class RemoteDataSource{

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance ;

  final collectionRef = FirebaseFirestore
      .instance
      .collection('users')
      .doc()
      .collection('tasks');

  Future<void> addNewTask(TaskModel task)async{
    await _fireStore
        .collection(FirebaseConstants.users)
        .doc(uid)
        .collection(FirebaseConstants.tasks)
        .doc(task.id)
        .set(task.toJson());
  }

  Future<void> updateTaskToFinished(String taskId)async{
    await _fireStore
        .collection(FirebaseConstants.users)
        .doc(uid)
        .collection(FirebaseConstants.tasks)
        .doc(taskId)
        .update({'isDone':true});
  }

  Future<List<TaskModel>> getAllTasks(List<String> cachedIDs)async{
    List<TaskModel> tasks = [];
    QuerySnapshot<Map<String, dynamic>> querySnapShot  ;
    if(cachedIDs.isNotEmpty){
      querySnapShot = await _fireStore
          .collection(FirebaseConstants.users)
          .doc(uid)
          .collection(FirebaseConstants.tasks)
          .where('id',whereNotIn: cachedIDs).get();
    }
    else{
      querySnapShot = await _fireStore
          .collection(FirebaseConstants.users)
          .doc(uid)
          .collection(FirebaseConstants.tasks)
          .get();
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