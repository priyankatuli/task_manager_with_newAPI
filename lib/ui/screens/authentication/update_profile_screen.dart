//update the screen

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/UI/widgets/background_widget.dart';
import 'package:task_manager/UI/widgets/profile_app_bar.dart';
import 'package:task_manager/data/model/api_response.dart';
import 'package:task_manager/data/model/user_data_model.dart';
import 'package:task_manager/data/network_caller/api_call.dart';
import 'package:task_manager/ui/controllers/authentication_controller.dart';
import 'package:task_manager/ui/utility/app_constants.dart';
import 'package:task_manager/ui/utility/url_list.dart';
import 'package:task_manager/ui/widgets/centered_progress_Indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class UpdateProfileScreen extends StatefulWidget{
  const UpdateProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() {
       return  _UpdateProfileScreenState();
  }

}

class  _UpdateProfileScreenState extends State<UpdateProfileScreen>{

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  XFile? _selectedImage;

  bool _updateProfileInProgress = false;


  @override
  void initState(){
    super.initState();

    final userData = AuthenticationController.userData!;
    _emailTEController.text = userData.email ?? '';
    _firstNameTEController.text = userData.firstName ?? '';
    _lastNameTEController.text = userData.lastName ?? '';
    _mobileTEController.text = userData.mobile ?? '';

  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: profileAppBar(context,true),
          body: BackgroundWidget(
            child: SingleChildScrollView(
               scrollDirection: Axis.vertical,
              child: Form(
                key: _formKey,
                child:  Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 48,),
                      Text('Update Profile',style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 16,),
                      _buildPhotoPicker(),
                      const SizedBox(height: 8,),
                      TextFormField(
                        controller: _emailTEController,
                        keyboardType: TextInputType.emailAddress,
                        enabled: false,
                        decoration: const InputDecoration(
                            hintText: 'Email'
                        ),
                      ),
                      const SizedBox(height: 8,),
                      TextFormField(
                        controller: _firstNameTEController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: 'First Name',
                        ),
                      ),
                      const SizedBox(height: 8,),
                      TextFormField(
                        controller: _lastNameTEController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            hintText: 'Last Name'
                        ),
                      ),
                      const SizedBox(height: 8,),
                      TextFormField(

                        controller: _mobileTEController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            hintText: 'Mobile'
                        ),
                        validator: (String ? value){
                          if(value?.trim().isEmpty ?? true){
                            return 'Enter your mobile number';
                          }
                          if(AppConstants.mobileRegExp.hasMatch(value!) == false){
                            return 'Enter your valid mobile number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8,),
                      TextFormField(
                        controller: _passwordTEController,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                            hintText: 'Password'
                        ),
                      ),
                      const SizedBox(height: 8,),
                      Visibility(
                        visible: _updateProfileInProgress == false,
                        replacement: const CenteredProgressIndicator(),
                        child:ElevatedButton(onPressed: (){
                          if(_formKey.currentState!.validate()) {
                            _updateProfile();
                          }
                      },
                            child: const Icon(Icons.arrow_circle_right_outlined,color: Colors.white,)),),

                      const SizedBox(height: 8,)
                    ],
                  ),
                ),
              )
            ),
          ),
        );
  }

  Widget _buildPhotoPicker() {
    return GestureDetector(
      onTap: (){
        _getImagePicker();
      },
      child: Container(
                        width: double.maxFinite,
                        height: 48,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white
                        ),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Container(
                                height:48,
                                width: 100,
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      bottomLeft: Radius.circular(8)
                                  ),
                                ),
                                alignment: Alignment.center,
                                child:const Text('Photo',style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Colors.white
                                ),),
                              ),
                            const SizedBox(width: 16,),
                            Expanded(
                                child: Text(_selectedImage?.name ?? 'No Image Selected',
                                  maxLines: 1,
                                  style: const TextStyle(
                                    overflow: TextOverflow.ellipsis
                                  ),
                                ),
                            ),
        ]
                        ),
                        ),

                        );}

  Future<void> _getImagePicker() async {
    
    ImagePicker imagePicker = ImagePicker();
    final XFile? result = await imagePicker.pickImage(
        source: ImageSource.gallery,
    );

    if(result!=null){
      //print('Image selected: ${_selectedImage!.path}');
      _selectedImage = result;
      if(mounted){
        setState(() {});
      }
      else{
        print('No Image Selected');
      }
    }
  }
  Future<void> _updateProfile() async{

    _updateProfileInProgress = true;
    String encodePhoto = AuthenticationController.userData?.photo ?? '';

    if(mounted){
      setState(() {});
    }

    Map<String, dynamic> requestBody = {

      "email": _emailTEController.text,
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),

    };

    if(_passwordTEController.text.isNotEmpty){
      requestBody['password'] = _passwordTEController.text;
    }

    if(_selectedImage != null){
      try {
        File file = File(_selectedImage!.path);
        encodePhoto = base64Encode(file.readAsBytesSync());
        requestBody['photo'] = encodePhoto;
      } catch(e){
         print('Image Encoding Failed $e');
      }
    }

    final ApiResponse response = await ApiCall.postResponse(UrlList.updateProfile,requestBody);

    if(response.isSuccess && response.responseData['status'] == 'success'){
      UserDataModel userModel = UserDataModel(

        email: _emailTEController.text,
        photo: encodePhoto,
        firstName: _firstNameTEController.text.trim(),
        lastName: _lastNameTEController.text.trim(),
        mobile: _mobileTEController.text.trim()
      );

      //update data save kore dibo //globally save hoye jabe
      await AuthenticationController.saveUserData(userModel);
      if(mounted){
        _clearTextFields();
        showSnackBarMessage(context, response.errorMessage ?? 'Profile Updated!!');
        Navigator.pop(context);
      }
    }

    else{
      if(mounted){
        showSnackBarMessage(context, response.errorMessage ?? 'Update profile failed!!Please try again');
      }
    }
   _updateProfileInProgress = false;
    if(mounted){
      setState(() {

      });
    }

  }

void _clearTextFields(){
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();
    _passwordTEController.clear();

}


  @override
  void dispose(){
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();


  }


}