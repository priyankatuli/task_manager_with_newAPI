import 'package:flutter/material.dart';
import 'package:task_manager/UI/widgets/background_widget.dart';
import 'package:task_manager/UI/widgets/task_item.dart';
import 'package:task_manager/data/model/api_response.dart';
import 'package:task_manager/data/model/task_list_wrapper_model.dart';
import 'package:task_manager/data/model/task_model.dart';
import 'package:task_manager/data/network_caller/api_call.dart';
import 'package:task_manager/ui/utility/url_list.dart';
import 'package:task_manager/ui/widgets/centered_progress_Indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';


class CancelledTaskScreen extends StatefulWidget{
  const CancelledTaskScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CancelledScreenState();
  }

}

class _CancelledScreenState extends State<CancelledTaskScreen>{

    bool _cancelledInProgress = false;
    List<TaskModel> cancelledTaskList = [];

    @override
  void initState(){
    super.initState();
    _getCancelledTask();
    }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: BackgroundWidget(
        child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
    child: Column(
    children: [
    const SizedBox(height: 10,),
    Expanded(
    child:
    RefreshIndicator(
        onRefresh: ()async{
          await _getCancelledTask();
        },
        child: Visibility(
          visible: _cancelledInProgress == false,
          replacement: const CenteredProgressIndicator(),
          child: ListView.builder(
            itemBuilder: (context,index){
              return TaskItem(
                taskModel: cancelledTaskList[index],
                onUpdateTask: (){
                  _getCancelledTask();
                },
              );
            },
            itemCount: cancelledTaskList.length,
          ),
        ),
      )
    ),],
    ),),
    ),
    );
  }

  Future<void> _getCancelledTask()async{

    _cancelledInProgress = true;
    if(mounted){
      setState(() {

      });
    }

    ApiResponse response = await ApiCall.getResponse(UrlList.cancelledTask);
    if(response.isSuccess){
      TaskListWrapperModel taskListWrapperModel = TaskListWrapperModel.fromJson(response.responseData);
      cancelledTaskList = taskListWrapperModel.task ?? [];
    }
    else{
      if(mounted){
        showSnackBarMessage(context, response.errorMessage ?? 'Cancelled task failed!! please try again');
      }
    }
    _cancelledInProgress = false;
    if(mounted){
      setState(() {

      });
    }

  }





}