import 'package:flutter/material.dart';
import 'package:task_manager/data/model/api_response.dart';
import 'package:task_manager/data/model/task_model.dart';
import 'package:task_manager/data/network_caller/api_call.dart';
import 'package:task_manager/ui/utility/url_list.dart';
import 'package:task_manager/ui/widgets/centered_progress_Indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class TaskItem extends StatefulWidget {

 const  TaskItem({
    super.key,
    required this.taskModel, required this.onUpdateTask,
 }
      );

  final TaskModel taskModel;
  final VoidCallback onUpdateTask;

  @override
  State<StatefulWidget> createState() {
      return _TaskItemState();
  }
}

class _TaskItemState extends State<TaskItem>{

  bool _deleteTaskInProgress = false;
  bool _editTaskStatusInProgress = false;

  String dropDownValue = '';

  List<String> taskStatusList = [
    'New',
    'Completed',
    'InProgress',
    'Cancelled'
  ];



  @override
  void initState(){
    super.initState();

    dropDownValue = widget.taskModel.status!;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.grey.withOpacity(0.7),
      child:  ListTile(
        title: Text(widget.taskModel.title ?? '',style:const TextStyle(
          ),),
        subtitle:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.taskModel.description ?? '',
            style: const TextStyle(
            ),
            ),
              Text(
              'Date: ${widget.taskModel.createdDate}',
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600
              ),),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(widget.taskModel.status ?? 'New',
                    style: const TextStyle(
                  color: Colors.black54,
                ),),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                ),
                ButtonBar(
                  children: [
                    Visibility(
                      visible: _deleteTaskInProgress == false,
                      replacement: const CenteredProgressIndicator(),
                      child: IconButton(onPressed: (){

                        _getDeleteTask();
                    },
                          icon:const Icon(Icons.delete,color: Colors.black54,)),
                    ),

                    //IconButton(onPressed: (){}, icon: const Icon(Icons.edit)),
                    
                    PopupMenuButton<String>(
                        icon: const Icon(Icons.edit,color: Colors.black54,),
                        onSelected: (String selectedValue){
                          dropDownValue = selectedValue;

                          if(mounted){
                            setState(() {

                            });
                          }
                          _getUpdateTaskStatus(selectedValue);

                        },
                        itemBuilder: (BuildContext context){
                            return taskStatusList.map((String value){
                                  return PopupMenuItem<String>(
                                    value : value,
                                    child : ListTile(
                                       title: Text(value),
                                       trailing: dropDownValue == value ? const Icon(Icons.done) : null ,
                                    )
                                  );
                            }).toList();
                        }
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }


  Future<void> _getDeleteTask() async{

    _deleteTaskInProgress = true;
    if(mounted){
      setState(() {

      });
    }

    ApiResponse response = await ApiCall.getResponse(UrlList.deleteTask(widget.taskModel.sId!));
    if(response.isSuccess && mounted){

      widget.onUpdateTask();
      showSnackBarMessage(context, 'Delete Successful!!');
    } else{
      if(mounted){
        showSnackBarMessage(context, response.errorMessage ?? 'Delete Task Failed');
      }
    }

    _deleteTaskInProgress = false;
    if(mounted){
      setState(() {

      });
    }


  }

Future<void> _getUpdateTaskStatus(String status)async{

    _editTaskStatusInProgress = true;
    if(mounted) {
      setState(() {

      });
    }
    ApiResponse response = await ApiCall.getResponse(UrlList.updateTask(widget.taskModel.sId!,
        status));

    if(response.isSuccess && mounted){

      widget.onUpdateTask();

    }else{
      if(mounted){
        showSnackBarMessage(context, response.errorMessage ?? 'Update task status failed!!please try again');
        Navigator.pop(context);
      }
    }

    _editTaskStatusInProgress = false;
    if(mounted){
      setState(() {

      });
    }


}







}