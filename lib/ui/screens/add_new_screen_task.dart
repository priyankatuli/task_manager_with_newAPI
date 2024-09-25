import 'package:flutter/material.dart';
import 'package:task_manager/UI/widgets/background_widget.dart';
import 'package:task_manager/UI/widgets/profile_app_bar.dart';
import 'package:task_manager/data/model/api_response.dart';
import 'package:task_manager/data/network_caller/api_call.dart';
import 'package:task_manager/ui/utility/url_list.dart';
import 'package:task_manager/ui/widgets/centered_progress_Indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';


class AddNewScreenTask extends StatefulWidget{
  const AddNewScreenTask({super.key});

  @override
  State<StatefulWidget> createState() {
       return _AddNewScreenTaskState();
  }

}

class _AddNewScreenTaskState extends State<AddNewScreenTask>{

  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController = TextEditingController();

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

bool _newTaskInProgress = false;


  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: profileAppBar(context),
          body: BackgroundWidget(
            child:  SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child:  Column(
                      children: [
                        TextFormField(
                          controller: _titleTEController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              hintText: 'Title'
                          ),
                          validator: (String ? value){
                            if(value?.trim().isEmpty ?? true ){
                              return 'Enter title';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: _descriptionTEController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                              hintText: 'Description'
                          ),
                          validator: (String ? value){
                            if(value?.trim().isEmpty ?? true){
                              return 'Enter description';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16,),
                        RefreshIndicator(
                            onRefresh: ()async{
                              _addNewTask();
                            },
                            child: Visibility(
                          visible: _newTaskInProgress == false,
                          replacement: const CenteredProgressIndicator(),
                          child: ElevatedButton(onPressed: (){

                            if(_formKey.currentState!.validate()){
                              //CALL NEW TASK API
                              _addNewTask();
                            }

                          }, child: const Text('Add')),))

                      ],
                    ),
                  )

              ),
            ),
          ),

        );
  }

  Future<void> _addNewTask() async{

    _newTaskInProgress = true;
    if(mounted) {
      setState(() {

      });
    }

    //request data prepara kora

    Map<String,dynamic> requestData ={

      "title": _titleTEController.text.trim(),
      "description": _descriptionTEController.text.trim(),
      "status":"New",
    };
    
    ApiResponse response = await ApiCall.postResponse(UrlList.createTask, requestData);

    _newTaskInProgress = false;
    if(mounted){
      setState(() {});
    }

    if(response.isSuccess){

      _clearTextFields();

      if(mounted){
        showSnackBarMessage(context, 'New task added');
        Navigator.pop(context);
      }
    }
    else{
      if(mounted){
        showSnackBarMessage(context, 'New task added failed!! please try again!!');
      }
    }

  }

  void _clearTextFields(){
    _titleTEController.clear();
    _descriptionTEController.clear();
  }



  @override
  void dispose(){
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();


  }

}