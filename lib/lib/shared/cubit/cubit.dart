import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/lib/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:to_do_app/lib/modules/done_tasks/done_tasks_screen.dart';
import 'package:to_do_app/lib/modules/new_tasks/new_tasks_screen.dart';
import 'package:to_do_app/lib/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
 AppCubit() : super(AppInitialStates());

 static AppCubit get(context) => BlocProvider.of(context);

 int currentIndex = 0;
 List<Widget> screen = [
  NewTasksScreen(),
  DoneTasksScreen(),
  ArchivedTasksScreen()
 ];

 List<String> titles = [
  'New Tasks',
  'Done Tasks',
  'Archived Tasks'
 ];

 Database? database;
 List<Map> newtasks = [];
 List<Map> donetasks = [];
 List<Map> archivedtasks = [];

 void createDatabase() {
  openDatabase(
   'todo.db',
   version: 1,
   onCreate: (database, version) {
    print('database created');
    database.execute(
     'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)',
    ).then((value) {
     print('table created');
    }).catchError((error) {
     print('Error when creating table: ${error.toString()}');
    });
   },
   onOpen: (database) {
    getDataFromDatabase(database);
    print('database opened');
   },
  ).then((value) {
   database = value;
   emit(AppCreateDatabaseState());
  });
 }

 void getDataFromDatabase(database) {
  newtasks = [];
  donetasks = [];
  archivedtasks = [];

  emit(AppGetDatabaseLoadingState());

  database.rawQuery('SELECT * FROM tasks').then((value) {
   value.forEach((element) {
    if (element['status'] == 'new') {
     newtasks.add(element);
    } else if (element['status'] == 'done') {
     donetasks.add(element);
    } else {
     archivedtasks.add(element);
    }
   });
   emit(AppGetDatabaseState());
  });
 }

 void insertToDatabase({
  required String title,
  required String time,
  required String date,
 }) async {
  await database!.transaction((txn) async {
   txn.rawInsert(
    'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")',
   ).then((value) {
    print('$value inserted successfully');
    emit(AppInsertDatabaseState());
    getDataFromDatabase(database);
   }).catchError((error) {
    print('Error when inserting new task: ${error.toString()}');
   });
  });
 }

 void updateDate({
  required String status,
  required int id,
 }) {
  database!.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
   getDataFromDatabase(database);
   emit(AppUpdateDatabaseState());
  });
 }

 void deletDate({
  required int id,
 }) {
  database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
   getDataFromDatabase(database);
   emit(AppDeleteDatabaseState());
  });
 }

 int fabIcon = Icons.edit.codePoint;
 bool isBottomSheetShow = false;

 void changeBottomSheetState({required bool isShow, required IconData icon}) {
  isBottomSheetShow = isShow;
  fabIcon = icon.codePoint;
  emit(AppChangeBottomSheetState());
 }

 void changeIndex(int index) {
  currentIndex = index;
  emit(AppChangeBottomNavBarState());
 }
}
