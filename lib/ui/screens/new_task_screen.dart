
import 'package:flutter/material.dart';
import 'package:task_manager/UI/screens/add_new_screen_task.dart';
import 'package:task_manager/UI/widgets/background_widget.dart';
import 'package:task_manager/UI/widgets/task_item.dart';
import 'package:task_manager/UI/widgets/task_summery_card.dart';
import 'package:task_manager/data/model/api_response.dart';
import 'package:task_manager/data/model/task_list_wrapper_model.dart';
import 'package:task_manager/data/model/task_model.dart';
import 'package:task_manager/data/model/task_status_count_model.dart';
import 'package:task_manager/data/model/task_status_count_wrapper_model.dart';
import 'package:task_manager/data/network_caller/api_call.dart';
import 'package:task_manager/ui/utility/url_list.dart';
import 'package:task_manager/ui/widgets/centered_progress_Indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';


class NewTaskScreen extends StatefulWidget{
  const NewTaskScreen({super.key});

  @override
  State<StatefulWidget> createState() {
       return _NewTaskScreenState();
  }

}

class _NewTaskScreenState extends State<NewTaskScreen> {

  bool _getNewTaskInProgress = false;
  List<TaskModel> newTaskList = [];


  bool _getTaskStatusCountInProgress = false;
  List<TaskStatusCountModel> taskStatusCountList =[];

  @override
  void initState() {
    super.initState();
    _getNewTasks();
    _getNewTaskStatusCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: //profileAppBar(),

      body: BackgroundWidget(
        child:  Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildSummerySection(),
              const SizedBox(height: 10,),
              Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      _getNewTasks();
                      _getNewTaskStatusCount();
                    },
                    child: Visibility(
                      visible: _getNewTaskInProgress == false,
                      replacement: const CenteredProgressIndicator(),
                      child: ListView.builder(
                        itemCount: newTaskList.length,
                        itemBuilder: (context, index) {
                          return TaskItem(
                            taskModel: newTaskList[index],
                            onUpdateTask: (){
                              _getNewTasks();
                              _getNewTaskStatusCount();
                            }

                          );
                        },),
                    ),
                  )
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddButton,
        backgroundColor: Colors.brown.shade200,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),

      ),
    );
  }

  void _onTapAddButton() {
    Navigator.push(context,
      MaterialPageRoute(builder: (context) => const AddNewScreenTask(),),);
  }

  Widget _buildSummerySection() {
    return Visibility(
          visible: _getTaskStatusCountInProgress == false,
          replacement: const SizedBox(
            height: 100,
            child: CenteredProgressIndicator(),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
              taskStatusCountList.map((e){
                return TaskSummaryCard(
                  count: e.sum.toString(),
                  title: (e.sId ?? 'Unknown').toUpperCase(),
                );
              }).toList(),
            ),
          ),
        );


  }

  Future<void> _getNewTasks() async {
    _getNewTaskInProgress = true;
    if (mounted) {
      setState(() {

      });
    }

    ApiResponse response = await ApiCall.getResponse(UrlList.newTask);

    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel = TaskListWrapperModel.fromJson(
          response.responseData);
      newTaskList = taskListWrapperModel.task ?? [];
    }
    else {
      if (mounted) {
        showSnackBarMessage(
            context,
            response.errorMessage ?? 'Get new task failed!! please try again');
      }
    }
    _getNewTaskInProgress = false;
    if (mounted) {
      setState(() {

      });
    }
  }

  Future<void> _getNewTaskStatusCount() async{

    _getTaskStatusCountInProgress = true;
    if(mounted){
      setState(() {

      });
    }

    ApiResponse response = await ApiCall.getResponse(UrlList.taskStatusCount);
    if(response.isSuccess){
      TaskStatusCountWrapperModel taskStatusCountWrapperModel = TaskStatusCountWrapperModel.fromJson(response.responseData);
      taskStatusCountList = taskStatusCountWrapperModel.taskCount ?? [];
    } else{
      if(mounted){
        showSnackBarMessage(context, response.errorMessage ?? 'Get task count by status failed!!Please try again');
      }
    }

    _getTaskStatusCountInProgress = false;
    if(mounted){
      setState(() {

      });
    }

  }


  @override
  void dispose(){
    super.dispose();



  }

}





