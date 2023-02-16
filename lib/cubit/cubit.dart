import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list_app/archived_tasks.dart';
import 'package:todo_list_app/cashe_helper.dart';
import 'package:todo_list_app/cubit/states.dart';
import 'package:todo_list_app/done_tasks.dart';
import 'package:todo_list_app/new_tasks.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit(): super(AppInitialState());

  static AppCubit get (context)=> BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = [
    NewTasksScreenScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> titles=[
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  void changeIndex(int index){
    currentIndex=index;
    emit(AppChangeBottomNavBarState());

  }

  Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  void createDatabase(){
    openDatabase(
      'ToDo.db',
      version: 1,
      onCreate: (database,version){
        print('database created');
        database.execute('CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)').then((value)
        {print('table created');
        }).catchError((error){
          print('Error When creating Table ${error.toString()}');
        });
      },
      onOpen: (database){

        getDataFromDataBase(database);
        print ('database opened');

      },
    ).then((value){
      database=value;
      emit(AppCreateDatabaseState());
    });
  }
  insertToDatabase({
    @required title,
    @required time,
    @required date,


  })async
  {
    await database.transaction((txn) {
      txn.rawInsert('INSERT INTO tasks(title, date , time , status) VALUES("$title","$date","$time","new")',
      ).then((value) {
        print('$value inserted successfully');
        emit(AppInsertToDatabaseState());
      }).catchError((error){
        print('Error When Inserting New Record ${error.toString()}');
      });
      return null;
    });

  }

  void getDataFromDataBase(database)
  {
    newTasks =[];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value)
    {

      value.forEach((element) {
        if(element['status']=='new')
          newTasks.add(element);
        else if(element['status']=='done')
          newTasks.add(element)  ;
        else archivedTasks.add(element);
      });
      emit(AppGetDatabaseState());

    });

  }
  void updateData({
    @required String status,
    @required int id ,
  })async{
    return await database.rawUpdate(
        'UPDATE tasks SET status = ?, WHERE id = ?',
        ['$status', id]
    ).then((value)
    {
      getDataFromDataBase(database);
      emit(AppUpdateDatabaseState());
    });
  }
  void deleteData({
    @required int id ,
  })async{
    return await database.rawDelete('DELETE FROM tasks WHERE id = ?', ['id']).then((value)
    {
      getDataFromDataBase(database);
      emit(AppDeleteDatabaseState());
    });
  }
  bool isBottomSheetShown =false;
  IconData fabIcon= Icons.edit;

  void changeBottomSheetState({
    @required bool isShow,
    @required IconData icon,
  })
  {
    isBottomSheetShown= isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());


  }
  bool isDark=false;
  ThemeMode appMode = ThemeMode.dark;
  void changeAppMode({bool fromShared}){
    if(fromShared !=null){
      isDark = fromShared;
      emit(AppChangeModeState());
    }
    else{
      isDark =!isDark;

      CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value)
      {
        emit(AppChangeModeState());
      });
    }

  }
}





