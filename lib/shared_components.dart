import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_app/cubit/cubit.dart';

Widget defaultButton({
  double width = double.infinity ,
  Color background = Colors.blue,
  double radius= 0.0,
  @required Function function,
  @required String text,
  bool isUpperCase = true

})=> Padding(
  padding: const EdgeInsets.all(20.0),
  child:
  Container(
    decoration: BoxDecoration(
        color: background ,
        borderRadius: BorderRadius.circular(radius)
    ),
    width:width,
    height: 40 ,
    child:
    MaterialButton(
      onPressed:function,

      child: Text(
        isUpperCase? text.toUpperCase():text ,
        style: TextStyle(color: Colors.white),),),
  ),
);

Widget defaultTextButton({
  @required Function function,
  @required String text,
})=> TextButton(
  onPressed: function,child:Text(text.toUpperCase()) ,
);


Widget  defaultFormField({
  @required TextEditingController controller,
  @required TextInputType type,
  Function onSubmit,
  Function onChange,
  Function onTap,
  bool isPassword = false,
  @required Function validate,
  @required String label,
  @required IconData prefix,
  IconData suffix,
  Function suffixPressed,
  bool isClickable = true
})=> TextFormField(
  keyboardType: type,
  obscureText: isPassword,
  enabled:isClickable ,
  onFieldSubmitted: onSubmit,
  onChanged: onChange,
  onTap: onTap,
  validator: validate,
  controller: controller,
  decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        prefix,
      ),
      suffixIcon:suffix!=null? IconButton(
        onPressed: suffixPressed,
        icon: Icon(
          suffix,
        ),
      ):null,
      border: OutlineInputBorder(
      )
  ),
);
Widget buildTaskItem(Map model,context)=>Dismissible(
  key: Key(model['id'].toString()),

  child:   Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 40,
          child: Text('${model['time']}'),
        ),

        SizedBox(width: 20),
        Expanded(

          child: Column(
            mainAxisSize:MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${model['title']}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${model['date']}',
                style: TextStyle(
                  color:Colors.grey,
                ),
              )
            ],
          ),
        ),
        SizedBox(width: 20),
        IconButton(icon: Icon(Icons.check_box),
            color: Colors.green,
            onPressed: (){
              AppCubit.get(context).updateData(
                  status: 'done', id: model['id']);
            }),

        IconButton(icon: Icon(Icons.archive),
            color: Colors.black45,
            onPressed: (){
              AppCubit.get(context).updateData(
                  status: 'archive', id: model['id']);
            }),
      ],
    ),
  ),
  onDismissed:(direction){
    AppCubit.get(context).deleteData(id:model['id'] );

  } ,
);
Widget tasksBuilder({
  @required List<Map> tasks})=> ListView.separated(
    itemBuilder: (context,index)=> buildTaskItem(tasks[index],context),
    separatorBuilder: (context,index)=>myDivider(),
    itemCount: tasks.length );

Widget myDivider()=>Padding(
  padding: const EdgeInsetsDirectional.only(
      start: 20.0
  ),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[300],
  ),
);

void navigateTo(context,widget)=> Navigator.push(
    context, MaterialPageRoute(
  builder: (context)=>widget,
)
);
void navigateAndFinish(context,widget)
=>
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(
      builder: (context)=>widget,
    ),
            (route){
          return false;
        }
    );


