import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/lib/components.dart';
import 'package:to_do_app/lib/shared/cubit/cubit.dart';
import 'package:to_do_app/lib/shared/cubit/states.dart';

class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        var tasks = AppCubit.get(context).newtasks;
        return tasksBuilder(tasks: tasks);
      },
    );
  }
}
