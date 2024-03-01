import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:ropulva_task/app/controllers/tasks_bloc.dart';
import 'package:ropulva_task/app/controllers/tasks_event.dart';
import 'package:ropulva_task/core/themes/colors.dart';

class InternetCheckerWidget extends StatefulWidget {
  const InternetCheckerWidget({super.key});

  @override
  State<InternetCheckerWidget> createState() => _InternetCheckerWidgetState();
}

class _InternetCheckerWidgetState extends State<InternetCheckerWidget> {
  bool _isConnected = false;
  bool _showWidget = false ;
  late StreamSubscription<InternetStatus> listener  ;

  @override
  void initState() {
    super.initState();
    listener = InternetConnection().onStatusChange.listen((InternetStatus status)async{
      switch (status) {
        case InternetStatus.connected:
          TasksBloc.get(context).add(LoadTasksEvent());
          setState(() {
            _isConnected = true ;
              _showWidget= true;
            });
            await Future.delayed(const Duration(seconds: 2));
            setState(() {
              _showWidget= false;
            });
          break;
        case InternetStatus.disconnected:
             setState(() {
               _isConnected = false ;
               _showWidget= true;
             });
          break;
      }
    });


  }
  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _showWidget
        ? AnimatedContainer(
        duration: const Duration(milliseconds:500),
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
          color: _isConnected
              ? MyColors.green
              : Colors.red,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                _isConnected
                    ? 'Online'
                    :'Offline',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white),
            ),
            const SizedBox(width: 10,),
            if(!_isConnected )
              const SizedBox(height:10,width:10,child: CircularProgressIndicator(color: Colors.white,))
          ],
        )
    )
        : const SizedBox();
  }
}
