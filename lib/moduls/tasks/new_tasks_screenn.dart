import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/componants/componants.dart';
import 'package:todo_app/shared/componants/conest.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class NewtasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     return BlocConsumer<AppCubit,AppStates>(
       listener: (context,state){},
       builder: (context,state){

         var tasks = AppCubit.get(context).newTasks;

         return tasksCondition(tasks: tasks);
       },

     );
  }
}
