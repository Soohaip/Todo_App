import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/componants/componants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class HomeScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, state) {
          if (state is AppInsertDatabase) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.screenTitle[cubit.currentIndex],
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 32,
              child: FloatingActionButton(
                onPressed: () {
                  if (cubit.isBottomSheetShown) {
                    if (formKey.currentState.validate()) {
                      cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text,
                      );
                    }
                  } else {
                    scaffoldKey.currentState.showBottomSheet((context) => Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 25,
                                    ),
                                    defultFormField(
                                      controller: titleController,
                                      type: TextInputType.text,
                                      label: 'Task Title',
                                      prefix: Icons.title,
                                      radius: 25,
                                      validate: (String value) {
                                        if (value.isEmpty) {
                                          return 'Title required';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: defultFormField(
                                            controller: timeController,
                                            type: TextInputType.datetime,
                                            label: 'Task Time',
                                            prefix: Icons.watch_later_outlined,
                                            radius: 25,
                                            ontabfield: () {
                                              showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now(),
                                              ).then((value) {
                                                timeController.text =
                                                    value.format(context);
                                              });
                                            },
                                            validate: (String value) {
                                              if (value.isEmpty) {
                                                return 'Time required';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: defultFormField(
                                            controller: dateController,
                                            type: TextInputType.datetime,
                                            label: 'Task Date',
                                            prefix: Icons.calendar_today,
                                            radius: 25,
                                            ontabfield: () {
                                              showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.parse('2021-12-30')).then((value) {
                                                dateController.text = DateFormat.yMMMd().format(value);
                                              });
                                            },
                                            validate: (String value) {
                                              if (value.isEmpty) {
                                                return 'Date required';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),).closed.then((value) {
                            titleController=null;
                            timeController=null;
                            dateController=null;
                      cubit.changeBottomSheet(isShow: false, icon: Icons.add);
                    });
                    cubit.changeBottomSheet(isShow: true, icon: Icons.check);
                  }
                },
                child: Icon(cubit.fabIcon),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
