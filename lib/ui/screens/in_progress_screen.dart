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


class InProgressScreen extends StatefulWidget{
  const InProgressScreen({super.key});


  @override
  State<StatefulWidget> createState() {
    return _NewTaskScreenState();
  }

}

class _NewTaskScreenState extends State<InProgressScreen>{


  bool _inProgress = false;

  List<TaskModel> inProgressTaskList = [];


  @override
  void initState(){
    super.initState();
    _getInProgress();


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
    child:RefreshIndicator(
        onRefresh: ()async{
          await _getInProgress();
        },
        child: Visibility(
          visible: _inProgress == false,
            replacement: const CenteredProgressIndicator(),
            child:  ListView.builder(
              itemBuilder: (context,index){
                return TaskItem(
                  taskModel: inProgressTaskList[index],
                  onUpdateTask: (){
                      _getInProgress();
                  },
                );
              },
              itemCount: inProgressTaskList.length,
            ),
        ),
      )
    ),],
    ))
    )
    );

  }

  Future<void> _getInProgress()async{
    _inProgress = true;
    if(mounted){
      setState(() {
        
      });
    }
    
    ApiResponse response = await ApiCall.getResponse(UrlList.inProgressTask);

    if(response.isSuccess){
      TaskListWrapperModel taskListWrapperModel = TaskListWrapperModel.fromJson(response.responseData);
      inProgressTaskList = taskListWrapperModel.task ?? [];
    }
    else{
      if(mounted){
        showSnackBarMessage(context, response.errorMessage ?? 'In progress task failed!!please try again');
      }
    }

    _inProgress = false;
    if(mounted){
      setState(() {

      });

    }

    
    
  }



}