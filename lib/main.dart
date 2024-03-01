import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ropulva_task/app/presentation/screens/home_screen.dart';
import 'package:ropulva_task/core/services/service_locator.dart';
import 'package:window_manager/window_manager.dart';
import 'app/data/models/task_model.dart';
import 'core/themes/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _installFirebase();
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
