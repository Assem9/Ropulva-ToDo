import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ropulva_task/app/presentation/screens/home_screen.dart';
import 'package:ropulva_task/core/services/cache_helper.dart';
import 'package:ropulva_task/core/services/service_locator.dart';
import 'package:window_manager/window_manager.dart';
import 'app/data/models/task_model.dart';
import 'core/themes/themes.dart';
import 'core/utils/constatnts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _installFirebase();
  await CacheHelper.init();
  await _createFakeUser();
  Hive.registerAdapter(TaskModelAdapter());
 // await _setWindowsDefaultSizes();
  ServiceLocator.initApp() ;
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      title: 'ToDo',
      theme: lightTheme,
      home: const HomeScreen(),
    );
  }
}

void _getDeviceToken() async {

}

Future<void> _installFirebase()async{
  if (Platform.isWindows){
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyD9YwTl4-gSk_cq44pk3lr5jCedpfDSmTI",
            appId: "1:472435994133:web:011b4cb8afbd25c47ee81c",
            messagingSenderId: "472435994133",
            projectId: "ropulvatask"
        )
    ) ;
    await _setWindowsDefaultSizes();
  }else{
    await Firebase.initializeApp();
  }
}

Future<void> _setWindowsDefaultSizes()async{
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(375, 671),
    minimumSize: Size(343, 671),
  //  maximumSize: Size(361, 758),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    fullScreen: false,
    windowButtonVisibility: true,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}

Future<void> _createFakeUser()async{
  uid = await CacheHelper.getData(key: 'uid');
  if(uid == null){
    final docRef = await FirebaseFirestore
        .instance
        .collection(FirebaseConstants.users)
        .add({'name': 'fakeUser'});
    uid = docRef.id;
    await CacheHelper.saveData(key: 'uid', value: uid);
  }
 print('fake uid ${uid}');
}