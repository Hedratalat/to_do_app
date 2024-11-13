import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/lib/components.dart';
import 'package:to_do_app/lib/shared/cubit/cubit.dart';
import 'package:to_do_app/lib/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final timingController = TextEditingController();
  final dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(), // فتح قاعدة البيانات هنا
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context); // إغلاق BottomSheet عند إدخال مهمة جديدة
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.black,

              title: Text(cubit.titles[cubit.currentIndex],
             style: TextStyle(color: Colors.white), ),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.screen[cubit.currentIndex],
              fallback: (context) => Center(
                child: CircularProgressIndicator(color: Colors.black),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: () {
                if (cubit.isBottomSheetShow) {
                  // إذا كان BottomSheet مفتوحًا، قم بإدخال المهمة
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                      title: titleController.text,
                      time: timingController.text,
                      date: dateController.text,
                    );
                  }
                } else {
                  // إذا لم يكن BottomSheet مفتوحًا، افتحه
                  scaffoldKey.currentState?.showBottomSheet(
                        (context) => Container(
                      color: Colors.grey[100],
                      padding: EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultFormField(
                              controller: titleController,
                              type: TextInputType.text,
                              label: 'Task Title',
                              prefixIcon: Icons.title,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return "Title must not be empty";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10.0),
                            defaultFormField(
                              controller: timingController,
                              type: TextInputType.datetime,
                              label: 'Task Time',
                              prefixIcon: Icons.watch_later_outlined,
                              onTap: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value) {
                                  if (value != null) {
                                    timingController.text =
                                        value.format(context).toString();
                                  }
                                });
                              },
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return "Time must not be empty";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10.0),
                            defaultFormField(
                              controller: dateController,
                              type: TextInputType.datetime,
                              label: 'Task Date',
                              prefixIcon: Icons.calendar_today,
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2050-05-01'),
                                ).then((value) {
                                  if (value != null) {
                                    dateController.text =
                                        DateFormat.yMMMd().format(value);
                                  }
                                });
                              },
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return "Date must not be empty";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).closed.then((value) {
                    // عند إغلاق BottomSheet، تغيير حالة الزر
                    cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(IconData(cubit.fabIcon, fontFamily: 'MaterialIcons')), // تحويل صحيح
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.black,
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
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
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey,
              selectedLabelStyle: TextStyle(color: Colors.white),
              unselectedLabelStyle: TextStyle(color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}
