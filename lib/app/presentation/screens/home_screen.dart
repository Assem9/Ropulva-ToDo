
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:ropulva_task/app/controllers/tasks_bloc.dart';
import 'package:ropulva_task/app/controllers/tasks_event.dart';
import 'package:ropulva_task/app/controllers/tasks_state.dart';
import 'package:ropulva_task/app/presentation/widgets/create_task_widget.dart';
import 'package:ropulva_task/app/presentation/widgets/default_button.dart';
import 'package:ropulva_task/app/presentation/widgets/internet_connection_widget.dart';
import 'package:ropulva_task/app/presentation/widgets/my_animated_toast.dart';
import 'package:ropulva_task/core/services/service_locator.dart';
import 'package:ropulva_task/core/themes/colors.dart';
import 'package:shimmer/shimmer.dart';
import '../../data/models/task_model.dart';
import '../widgets/filter_widget.dart';
import '../widgets/task_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value:  getIt<TasksBloc>(),
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if(Platform.isAndroid)
                  SizedBox(height: MediaQuery.of(context).padding.top),
                const InternetCheckerWidget(),
                const SizedBox(
                  height: 31,
                ),
                _buildTopBarWidget(context),
               // DefaultButton(text: 'Test', onTap: ()=>MyToast.show(
               //     context: context,
               //     message: 'Task Finished!!!',
               //     showOverLottie: true
               // )),
               const SizedBox(height: 16,),
                _buildTasksGridView(),
                Stack(
                  children: [
                    if(MediaQuery.sizeOf(context).width < 800)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10 ),
                        child: DefaultButton(
                          text: "Create Task",
                          onTap: ()=> _showCreateNewTaskBottomSheet(context),
                        ),
                      ) ,
                    BlocConsumer<TasksBloc, TasksState>(
                        listener:  (context, state) {
                          if(state.finishTaskRequest == RequestState.error){
                            MyToast.show(
                                context: context,
                                message: state.error,
                                toastState: ToastState.error
                            );
                          }
                          if(state.finishTaskRequest == RequestState.success){
                            MyToast.show(
                              context: context,
                              message: 'Task Finished!!!',
                              showOverLottie: true
                            );
                          }
                        },
                        listenWhen: (previous,current)=> previous.finishTaskRequest !=current.finishTaskRequest,
                        buildWhen: (previous,current)=> previous.showDragTarget != current.showDragTarget,
                        builder: (context, state) {
                          print('builder showDragTarget ${state.finishTaskRequest}');
                          if( state.showDragTarget){
                            return Container(color:Colors.white,child: const AnimatedDragTarget( ));
                          }
                          return const SizedBox();
                        }
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBarWidget(BuildContext context){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                'Good Morning',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 16,),
            _buildTaskFilters(),
          ],
        ),
        if(MediaQuery.sizeOf(context).width > 800)
          Padding(
            padding: const EdgeInsets.only(right: 94),
            child: InkWell(
              onTap: (){
                final formKey = GlobalKey<FormState>();
                final titleController=  TextEditingController();
                final dueDateController =  TextEditingController();
                showDialog(
                    context: context,
                    builder: (_){
                      return AlertDialog(
                        backgroundColor: MyColors.cardColor,
                        surfaceTintColor: MyColors.cardColor,
                        content:BlocProvider.value(
                          value:  getIt<TasksBloc>(),
                          child: CreateTaskWidget(
                              formKey: formKey,
                              titleController: titleController,
                              dueDateController: dueDateController
                          ),
                        ),
                      );
                    }
                );
              },
              child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: MyColors.green,
                  ),
                  child: const Icon(Icons.add,color: Colors.white,size: 47,)),
            ),
          )
      ],
    );
  }

  Widget _buildTasksGridView( ) {
    return BlocConsumer<TasksBloc, TasksState>(
      listener:  (context, state) {
        if(state.getTasksRequest == RequestState.error){
          MyToast.show(
              context: context,
              message: state.error,
              toastState: ToastState.error
          );
        }
        if(state.getTasksRequest == RequestState.success){
          MyToast.show(
              context: context,
              message: 'Tasks Loaded',
          );
        }
      },
      listenWhen: (previous,current)=> previous.getTasksRequest !=current.getTasksRequest,
      buildWhen: (previous,current)=>
      previous.tasks != current.tasks
      || previous.finishTaskRequest != current.finishTaskRequest
      || previous.addNewTaskRequest != current.addNewTaskRequest   ,
      builder: (context, state) {
        if(state.getTasksRequest != RequestState.loading){
          return Expanded(
            child:   RefreshIndicator(
              onRefresh: () async{
                TasksBloc.get(context).add(LoadTasksEvent()) ;
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 500,
                    mainAxisExtent: 110,
                  ),
                  itemCount: state.tasks.length,
                  itemBuilder: (context, index) => TaskWidget(task: state.tasks[index]),
                ),
              ),
            ),
          );
        }
        return _buildTasksShimmerLoading();

      },
    );
  }

  Widget _buildTasksShimmerLoading() {
    return  Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          enabled: true,
          child: const SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: const Card(
                    elevation: 9,
                  ),
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: Card(
                    elevation: 9,
                  ),
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: Card(
                    elevation: 9,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _showCreateNewTaskBottomSheet(BuildContext context){
    final formKey = GlobalKey<FormState>();
    final titleController=  TextEditingController();
    final dueDateController =  TextEditingController();
    showModalBottomSheet(
        context: context,
        barrierColor: Colors.white10,
        isScrollControlled: true,
        builder: (_)=> BlocProvider.value(
          value:  getIt<TasksBloc>(),
          child: Padding(
            padding: EdgeInsets.only(
              right: 8,left: 8,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10)
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0,-2),
                          blurRadius: 5,
                          spreadRadius: 2
                      ),
                      BoxShadow(
                          color: Colors.white,
                          offset: Offset(4,4),
                          blurRadius: 25
                      ),
                    ]
                ),
                child: CreateTaskWidget(
                  formKey: formKey,
                  titleController: titleController,
                  dueDateController: dueDateController,
                )
            ),
          ),
        )
    );
  }

  Widget _buildTaskFilters()=> BlocBuilder<TasksBloc, TasksState>(
    buildWhen: (previous,current)=>previous.currentFilter != current.currentFilter,
    builder: (context, state) {
      return  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DefaultChip(
              filter: TaskFilter.all,
              onTap: (){},
              isSelected:(TaskFilter.all == state.currentFilter) ,
            ),
            const SizedBox(width: 5,),
            DefaultChip(
              filter:TaskFilter.notDone,
              onTap: (){},
              isSelected: (TaskFilter.notDone  == state.currentFilter) ,
            ),
            const SizedBox(width: 5,),
            DefaultChip(
              filter: TaskFilter.done,
              onTap: (){},
              isSelected: (TaskFilter.done == state.currentFilter) ,
            ),
          ],
        ),
      );
    },
  );


}



class AnimatedDragTarget extends StatefulWidget {
  const AnimatedDragTarget({super.key});

  @override
  State<AnimatedDragTarget> createState() => _AnimatedDragTargetState();
}

class _AnimatedDragTargetState extends State<AnimatedDragTarget> {
  List<Color> secondaryColors = const [
    MyColors.green,
    MyColors.lightGreen,
    Colors.white,
  ];
  List<Color> primaryColors = const [
    Colors.white10,
    Colors.white30,
    MyColors.lightGreen,
  ];
  late Gradient _currentGradient;
  bool _isPrimary = true;

  @override
  void initState() {
    super.initState();
    _currentGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: primaryColors,
    );
    _startAnimation();
  }

  void _startAnimation() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _currentGradient = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _isPrimary ? secondaryColors : primaryColors,
          );
          _isPrimary = !_isPrimary;
          _startAnimation();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10 ),
      child: Center(
        child: DragTarget(
            onAccept: (TaskModel? task) {
              if(task !=null){
                TasksBloc.get(context).add(FinishTaskEvent(task));
              }
            },
            builder: (BuildContext context, List<dynamic> accepted, List<dynamic> rejected,) {
              return AnimatedContainer(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.8,
                alignment: AlignmentDirectional.center,
                margin: const EdgeInsets.only(bottom: 20),
                duration: const Duration(seconds: 1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.white10,
                      offset: Offset(2, 0),
                      blurRadius: 10,
                      spreadRadius: 6,
                    ),
                    BoxShadow(
                      color: Colors.green,
                      offset: Offset(2, 0),
                      blurRadius: 12,
                      spreadRadius: 0.2,
                    ),
                  ],
                  gradient: _currentGradient,
                ),
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: AlignmentDirectional.center,
                  child: Text(
                    'Task is Done!!!!',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
                  ),
                ),
              );
            }
        ),
      ),
    );
  }
}









