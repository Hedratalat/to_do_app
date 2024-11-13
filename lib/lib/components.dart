import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/lib/shared/cubit/cubit.dart';

// تعريف الدالة defaultFormField
Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String label,
  required IconData prefixIcon,
  required String? Function(String?) validate,
  VoidCallback? onTap, //// إضافة خاصية onTap
  bool isClikable = true,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: type,
    validator: validate,
    onTap: onTap, // استدعاء onTap عند الضغط على الحقل
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(prefixIcon),
      border: OutlineInputBorder(),
      enabled: isClikable,
    ),
  );

}

Widget buildTaskItem(Map model , context) => Dismissible(
  key: Key(model['id'].toString()),
  child:   Padding(
  
    padding: const EdgeInsets.all(20.0),
  
    child: Row(
  
      children: [
  
        CircleAvatar(
  
          radius: 40.0,
  
          backgroundColor: Colors.black38,
  
          child: Text(
  
            '${model['time']}',
  
            style: TextStyle(
  
              color: Colors.white,
  
            ),
  
          ),
  
        ),
  
        SizedBox(width: 20.0,),
  
        Expanded(
  
          child: Column(
  
            mainAxisSize: MainAxisSize.min,
  
            crossAxisAlignment: CrossAxisAlignment.start,
  
            children: [
  
              Text(
  
                '${model['title']}',
  
                style: TextStyle(
  
                  fontSize: 18.0,
  
                  fontWeight: FontWeight.bold,
  
                ),
  
              ),
  
              SizedBox(height: 2,),
  
              Text(
  
                '${model['date']}',
  
                style: TextStyle(
  
                  color: Colors.grey,
  
                ),
  
              ),
  
  
  
            ],
  
          ),
  
        ),
  
        SizedBox(width: 20.0,),
  
        IconButton(
  
          icon: Icon(Icons.check_box,
  
          color: Colors.cyan,), onPressed: () {
  
  
  
             AppCubit.get(context).updateDate(status: 'done', id: model['id'],);
  
        },
  
  
  
        ),
  
        IconButton(
  
          icon: Icon(Icons.archive,
  
          color: Colors.blueGrey,
  
          ), onPressed: () {
  
          AppCubit.get(context).updateDate(status: 'archive', id: model['id'],);
  
  
  
        },
  
  
  
        ),
  
  
  
      ],
  
    ),
  
  ),
onDismissed: (direction){
 AppCubit.get(context).deletDate(id: model['id']);
},
);

Widget tasksBuilder({
  required List<Map> tasks,
}) =>  ConditionalBuilder(
  condition: tasks.length >0 ,
  builder:(context) => ListView.separated(
    itemBuilder: (context,index)=> buildTaskItem(tasks[index],context) ,
    separatorBuilder: (context,index) => Container(
      width: double.infinity,
      height: 1.0,
      color: Colors.grey[300],
    ),
    itemCount:tasks.length,
  ),
  fallback: (context) =>Center(
    child: Column(
      mainAxisAlignment:MainAxisAlignment.center ,
      children: [
        Icon(Icons.menu,
          size: 80.0,
          color: Colors.grey,),
        Text(
          'No Tasks Yet, Please Add Some Tasks',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),

        )
      ],
    ),
  ),
);
