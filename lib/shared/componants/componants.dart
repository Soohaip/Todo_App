import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget defultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 0.0,
  @required Function function,
  @required String text,
}) => Container(
      width: double.infinity,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        color: background,
        padding: EdgeInsets.all(15),
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );

Widget defultFormField({
  @required TextEditingController controller,
  @required TextInputType type,
  double radius = 0.0,
  @required String label,
  Function onChange,
  Function onSubmit,
  Function ontabfield,
  @required IconData prefix,
  IconData suffix,
  Function validate,
  bool isPassword = false,
  Function suffixPresse,
  bool isClickable = true,
}) => TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null ? IconButton(
                onPressed: suffixPresse,
                icon: Icon(suffix),
              ) : null,
      ),
      obscureText: isPassword,
      validator: validate,
      onTap: ontabfield,
      enabled: isClickable,
      onChanged: onChange,
      onFieldSubmitted: onSubmit,
      controller: controller,
    );

Widget buildListItem(Map model,context) => Dismissible(
  key: Key(model['id'].toString()),
  onDismissed: (direction){
    AppCubit.get(context).deleteData(id: model['id'], );
  },
  child:Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              child: Text(
                '${model['id']}',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        '${model['time']}',
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        '${model['date']}',
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updateData(
                  status: 'done',
                  id: model['id'],
                );
              },
              icon: Icon(Icons.check_circle_outline),
              color: Colors.grey[400],
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updateData(
                    status: 'archived',
                    id: model['id'],
                );
              },
              icon: Icon(Icons.archive_outlined),
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
);


Widget tasksCondition ({
  @required List<Map> tasks,
})=>ConditionalBuilder(
  condition: tasks.length >0,
  builder: (context)=>ListView.separated(
    itemBuilder: (context, index) => buildListItem(tasks[index],context),
    separatorBuilder: (context, index) => Container(
      width: 2,
      height: 1,
      color: Colors.grey[300],
    ),
    itemCount: tasks.length,
  ),
  fallback: (context)=> Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size: 100,
          color: Colors.grey,
        ),
        SizedBox(height: 10,),
        Text(
          'No tasks yet',
          style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.grey),
        ),
      ],
    ),
  ),
);
