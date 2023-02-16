import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list_app/cubit/cubit.dart';
import 'package:todo_list_app/cubit/states.dart';
import 'package:todo_list_app/shared_components.dart';

class HomeLayout extends StatelessWidget
{
  var scaffoldKey=GlobalKey<ScaffoldState>();
  var formKey=GlobalKey<FormState>();
  var titleController=TextEditingController();
  var timeController=TextEditingController();
  var dateController=TextEditingController();

  Database database;

  @override
  Widget build(BuildContext context)
  {
    return BlocProvider(
      create: (BuildContext context) =>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>
        (
        listener: (BuildContext context, AppStates state){
          if(state is AppInsertToDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context,AppStates state){
          AppCubit cubit = AppCubit.get(context);
          return
            Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text(
                    cubit.titles[cubit.currentIndex]
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if(cubit.isBottomSheetShown){
                    if(formKey.currentState.validate()){
                      cubit.insertToDatabase(
                          title: titleController.text,
                          time: timeController.text,
                          date: dateController.text
                      );
                    }
                  } else{
                    scaffoldKey.currentState.showBottomSheet((context) =>Container(
                      color: Colors.white,
                      padding:EdgeInsets.all(20),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize:MainAxisSize.min,
                          children: [
                            defaultFormField(
                              controller: titleController,
                              type: TextInputType.text,
                              validate: (String value){
                                if(value.isEmpty){
                                  return 'title must not be empty ';
                                }return null;
                              },
                              label: 'Task Title',
                              prefix: Icons.title,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            defaultFormField(
                              controller: timeController,
                              type: TextInputType.datetime,
                              onTap: (){
                                showTimePicker
                                  (context: context, initialTime: TimeOfDay.now()).then((value){
                                  timeController.text = value.format(context).toString();
                                });
                              },
                              validate: (String value){
                                if(value.isEmpty){
                                  return 'time must not be empty ';
                                }return null;
                              },
                              label: 'Task time',
                              prefix: Icons.watch_later_outlined,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            defaultFormField(
                                controller:dateController ,
                                type: TextInputType.datetime,
                                onTap: (){
                                  showDatePicker(context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2027-05-03')
                                  ).then((value){
                                    dateController.text=DateFormat.yMMMd().format(value);
                                  });
                                },
                                validate: (String value){
                                  if(value.isEmpty){
                                    return 'date must not be empty ';
                                  }return null;
                                },
                                label: 'Task date' ,
                                prefix: Icons.calendar_today)
                          ],
                        ),
                      ),
                    ),
                      elevation: 20,
                    ).closed.then((value){
                      cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                    });
                    cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                  }
                },
                child: Icon(cubit.fabIcon),
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                elevation: 10,
                currentIndex:cubit.currentIndex,
                onTap: (index){
                  cubit.changeIndex(index);
                },
                items: [
                  BottomNavigationBarItem(icon:  Icon(Icons.menu),
                      label: '  New Tasks'),
                  BottomNavigationBarItem(icon:  Icon(Icons.check),
                      label: 'Done Tasks') ,
                  BottomNavigationBarItem(icon:  Icon(Icons.archive_outlined),
                      label: 'Archived Tasks')
                ],
              ),
            );
        },
      ),
    );
  }
  // void insertToDatabase()
  // {
  //   database.transaction((txn) {
  //     txn.rawInsert('INSERT INTO tasks(title, date, time, status) VALUES("first task","0222","891","new")').then((value) {
  //       print('$value inserted successfully');
  //     }).catchError((error) {
  //       print('Error when Inserting New Record ${error.toString()}');
  //     });
  //     return null;
  //   });
  // }
}

