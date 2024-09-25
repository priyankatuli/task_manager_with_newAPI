import 'package:flutter/material.dart';
import 'package:task_manager/UI/widgets/background_widget.dart';
import 'package:task_manager/data/model/api_response.dart';
import 'package:task_manager/data/model/task_list_wrapper_model.dart';
import 'package:task_manager/data/model/task_model.dart';
import 'package:task_manager/data/network_caller/api_call.dart';
import 'package:task_manager/ui/utility/url_list.dart';
import 'package:task_manager/ui/widgets/centered_progress_Indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

import '../widgets/task_item.dart';


class CompletedScreen extends StatefulWidget{
  const CompletedScreen({super.key});


  @override
  State<StatefulWidget> createState() {
    return _NewTaskScreenState();
  }

}

class _NewTaskScreenState extends State<CompletedScreen>{


  bool _getCompletedTaskInProgress = false;
  List<TaskModel> completedTaskList = [];


  @override
  void initState(){
    super.initState();
    _getCompletedTask();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //appBar: profileAppBar(),
      body: BackgroundWidget(
        child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
          child: Column(
            children: [
              //_buildSummerySection(),
              const SizedBox(height: 10,),
              Expanded(
                  child: RefreshIndicator(
                    onRefresh: ()async{
                      _getCompletedTask();
                    },
                    child: Visibility(
                      visible: _getCompletedTaskInProgress == false,
                      replacement: const CenteredProgressIndicator(),
                      child: ListView.builder(
                        itemBuilder: (context,index){
                          return TaskItem(
                            taskModel: completedTaskList[index],
                            onUpdateTask: (){
                              _getCompletedTask();
                            },
                          );
                        },
                        itemCount: completedTaskList.length,
                      ),
                    ),
                  )
              )

            ],
          ),
        )
      ),
    );
  }

  Future<void> _getCompletedTask() async{
    _getCompletedTaskInProgress = true;

    if(mounted){
      setState(() {

      });
    }

    ApiResponse response = await ApiCall.getResponse(UrlList.completedTask);

    if(response.isSuccess){
      TaskListWrapperModel taskListWrapperModel = TaskListWrapperModel.fromJson(response.responseData);
      completedTaskList = taskListWrapperModel.task ?? [];

    }
    else{
      if(mounted){
        showSnackBarMessage(context, response.errorMessage ?? 'Completed task failed!! please try again');
      }
    }

    _getCompletedTaskInProgress = false;
    if(mounted){
      setState(() {

      });
    }

  }

/*
  Future<void> _getCompletedTaskStatusCount() async{

    _getCompletedTaskStatusCountInProgress = true;
    if(mounted){
      setState(() {

      });
    }

    ApiResponse response = await ApiCall.getResponse(UrlList.taskStatusCount);
    if(response.isSuccess){
      TaskStatusCountWrapperModel taskStatusCountWrapperModel = TaskStatusCountWrapperModel.fromJson(response.responseData);
      completedTaskStatusCountList = taskStatusCountWrapperModel.taskCount ?? [];
    } else{
      if(mounted){
        showSnackBarMessage(context, response.errorMessage ?? 'Get task count by status failed!!Please try again');
      }
    }

    _getCompletedTaskStatusCountInProgress = false;
    if(mounted){
      setState(() {

      });
    }

  }
*/
  /*
  Widget _buildSummerySection(){
    return Visibility(
        visible: _getCompletedTaskStatusCountInProgress == false,
        replacement: const SizedBox(
          height: 100,
          child: CenteredProgressIndicator(),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [

            ],
          ),
        )
    );
  }
*/

}