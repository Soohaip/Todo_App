import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/moduls/archived/archived_tasks_screenn.dart';
import 'package:todo_app/moduls/dones/done_tasks_screenn.dart';
import 'package:todo_app/moduls/tasks/new_tasks_screenn.dart';
import 'package:todo_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  var currentIndex = 0;

  Database database;
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.add;

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  List<Widget> screens = [
    NewtasksScreen(),
    DonetasksScreen(),
    ArchivedtasksScreen(),
  ];
  List<String> screenTitle = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase() async {
    openDatabase('todo.db', version: 1,
      onCreate: (database, version) {
        database.execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('error : ${error.toString()}');
        });
        print('db created');
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabase());
    });
  }

  insertToDatabase({
    @required String title,
    @required String time,
    @required String date,
  }) async {
    await database.transaction((txn) {
      txn.rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
        print('$value inserted ');
        emit(AppInsertDatabase());

        getDataFromDatabase(database);
      }).catchError((error) {
        print('error in insert : ${error.toString()}');
      });
      return null;
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(AppGetDatabaseLoadingState());

    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });
      emit(AppGetDatabase());
    });
  }

  void updateData({
    @required String status,
    @required int id,
  }) async {
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id  = ?',
      ['$status', id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabase());
    });
  }

  void deleteData({
    @required int id,
  }) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabase());
    });
  }

  void changeBottomSheet({@required bool isShow, @required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;

    emit(AppChangeBottomSheetState());
  }
}
