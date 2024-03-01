
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ropulva_task/app/controllers/tasks_bloc.dart';
import 'package:ropulva_task/app/controllers/tasks_event.dart';
import 'package:ropulva_task/app/data/data_sources/local_data_source.dart';
import 'package:ropulva_task/app/data/models/task_model.dart';
import 'package:ropulva_task/app/presentation/widgets/default_loader.dart';
import '../../../core/themes/colors.dart';
import '../../controllers/tasks_state.dart';
import 'default_button.dart';
import 'my_animated_toast.dart';

class CreateTaskWidget extends StatelessWidget {
  const CreateTaskWidget({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.dueDateController
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController dueDateController;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.only(top:14,left: 17,right: 17,bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
                alignment:AlignmentDirectional.topEnd,
                child: IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    visualDensity: VisualDensity(horizontal: 0,vertical: 0),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: Icon(Icons.close,color: Color(0xffF24E1E),)
                )
            ),
            Text(
              'Create New Task',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 17,),
            DefaultTextField(controller: titleController, hint: "Task title",),

            const SizedBox(height: 8,),
            DefaultTextField(
              hint: "Due Date",
                controller: dueDateController,
                onTap: ()=> _pickDueDate(context),
            ),
            const SizedBox(height: 30,),
            BlocConsumer<TasksBloc, TasksState>(
                listener: (context, state){
                  if(state.addNewTaskRequest == RequestState.success){
                    MyToast.show(
                        context: context,
                        message: 'Task Added Successfully',
                    );
                    Navigator.pop(context);
                  }
                  if(state.addNewTaskRequest == RequestState.error){
                    MyToast.show(
                      context: context,
                      message: state.error,
                      toastState: ToastState.error
                    );
                  }
                },
                buildWhen: (previous,current)=> previous.addNewTaskRequest != current.addNewTaskRequest  ,
                builder: (context, state) {
                  print('add=> ${state.addNewTaskRequest}');
                  if(state.addNewTaskRequest == RequestState.loading){
                    return const DefaultLoader();
                  }
                return DefaultButton(
                    text: "Save Task",
                    onTap: (){
                      if(formKey.currentState!.validate()){
                        TasksBloc.get(context).add(AddNewTaskEvent(
                            title: titleController.text,
                            dueDate: DateTime.tryParse(dueDateController.text)!,
                        ));
                      }
                    }
                );
              }
            )
          ],
        ),
      ),
    );
  }

  void _pickDueDate(BuildContext context)async{
    DateTime? dateTime = await
    showDatePicker(
        context: context,
        firstDate: DateTime.now().add(const Duration(minutes: 10)),
        lastDate: DateTime(2025)
    );
    if(dateTime != null){
      TimeOfDay? time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now()
      );
      if(time != null){
        dateTime = DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          time.hour,
          time.minute,
        );
      }
      //_dueDateController.text = DateFormat('E. d/M/yyyy').format(dateTime);
      dueDateController.text = dateTime.toIso8601String();
      //DateFormat('E. d/M/yyyy').format(time)
      //print('parese :${DateTime.tryParse(dateTime.toIso8601String())}');
      print('.value.text :${DateTime.tryParse(dueDateController.value.text)}');
    }
  }



}

class DefaultTextField extends StatefulWidget {
  const DefaultTextField({super.key, this.controller, required this.hint, this.onTap});
  final TextEditingController? controller ;
  final String hint;
  final Function()? onTap;

  @override
  State<DefaultTextField> createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField> {

  bool errorShown = false ;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: errorShown? 60 : 33,
      child: TextFormField(
        controller: widget.controller,
        keyboardType: TextInputType.text,
        textAlign: TextAlign.start,
        onTap: widget.onTap,
        readOnly: widget.onTap != null ? true :false,
        validator: (value) {
          if (value?.isEmpty ?? true) {
            setState(() {
              errorShown = true;
            });
            return '${widget.hint} must not be empty';
          } else {
            errorShown = false;
            return null;
          }

        },
        style: Theme.of(context).textTheme.bodySmall,
        decoration: InputDecoration(

          hintText: widget.hint,
          hintStyle:  Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey),
          filled: true,
          errorStyle: const TextStyle(fontSize:10),
          fillColor: MyColors.cardColor,
          contentPadding: const EdgeInsets.only(left: 20),
          border: OutlineInputBorder(
            gapPadding: 0,
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}