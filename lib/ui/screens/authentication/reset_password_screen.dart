
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/UI/screens/authentication/sign_in_screen.dart';
import 'package:task_manager/UI/utility/app_colors.dart';
import 'package:task_manager/UI/widgets/background_widget.dart';
import 'package:task_manager/data/model/api_response.dart';
import 'package:task_manager/data/network_caller/api_call.dart';
import 'package:task_manager/ui/utility/app_constants.dart';
import 'package:task_manager/ui/utility/url_list.dart';
import 'package:task_manager/ui/widgets/centered_progress_Indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';


class ResetPasswordScreen extends StatefulWidget{
  const ResetPasswordScreen({super.key,
    required this.email, required this.pinCode});

  final String email;
  final String pinCode;

  @override
  State<StatefulWidget> createState() {

    return _ResetPasswordScreenState();
  }

}


class _ResetPasswordScreenState extends State<ResetPasswordScreen>{


  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _resetPasswordInProgress = false;

  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
            child: SingleChildScrollView(
              child:  Padding(padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 100,),
                      Text('Set Password',style: Theme.of(context).textTheme.titleLarge,),
                      const SizedBox(height: 10,),
                      Text('Minimum length password 8 character with latter and number combination',
                      style: Theme.of(context).textTheme.bodySmall
                      ),
                      const SizedBox(height: 24,),
                      TextFormField(
                        controller: _passwordTEController,
                        obscureText: _showPassword == false,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            suffixIcon: IconButton(
                              onPressed: (){
                                _showPassword = !_showPassword;
                                if(mounted){
                                  setState(() {

                                  });
                                }
                              }, icon: Icon(_showPassword ? Icons.remove_red_eye : Icons.visibility_off),
                            )
                        ),
                        validator: (String ? value){
                          if(value?.trim().isEmpty ?? true){
                            return 'Enter your password';
                          }
                          if(AppConstants.passwordRegExp.hasMatch(value!) == false){
                            return 'Must Contain 8 characters or more';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10,),
                      TextFormField(
                        obscureText: _showPassword == false,
                        controller: _confirmPasswordEController,
                        decoration: InputDecoration(
                            hintText: 'Confirm Password',
                          suffixIcon: IconButton(
                            onPressed: (){
                              _showPassword = !_showPassword;
                              if(mounted){
                                setState(() {
                                  
                                });
                              }
                            }, icon: Icon(_showPassword ? Icons.remove_red_eye : Icons.visibility_off),
                          )
                        ),
                      ),
                      const SizedBox(height: 16,),
                      Visibility(
                          visible: _resetPasswordInProgress == false,
                          replacement: const CenteredProgressIndicator(),
                          child: ElevatedButton(onPressed: (){
                            if(_formKey.currentState!.validate()) {
                              if(_passwordTEController.text == _confirmPasswordEController.text){
                              _getResetPassword();}
                            }
                          }, child: const Text('Confirm')),),

                      const SizedBox(height: 36,),
                      _buildHaveAccount(),
                    ],
                  ),
                ),
              ),
            )
        ),
      ),
    );
  }

  Widget _buildHaveAccount() {
    return Center(
                    child:
                        RichText(text: TextSpan(
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.4
                            ),
                            text: "Have Account? ",
                            children:  [
                              TextSpan(
                                  text: 'Sign In',
                                  style: const TextStyle(
                                      color: AppColors.themeColor
                                  ),
                                  recognizer: TapGestureRecognizer()..onTap =() {
                                    _onTapSignInButton();
                                  }
                              ),
                            ]
                        ))
                  );
  }
  
  
  Future<void> _getResetPassword()async{
    
    _resetPasswordInProgress = true;
    if(mounted){
      setState(() {
        
      });
    }

     Map<String, dynamic> requestInput = {
       "email": widget.email,
       "OTP": widget.pinCode,
       "password": _confirmPasswordEController.text.trim()
     };
    ApiResponse response = await ApiCall.postResponse(UrlList.recoverResetPass, requestInput);

    _resetPasswordInProgress = false;
    if(mounted){
      setState(() {

      });
    }

    if(response.isSuccess && response.responseData['status'] == 'success') {

      if (mounted) {
        _clearTextFields();
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => const SignInScreen()),
                (route) => false
        );
        showSnackBarMessage(context, 'Reset password Successful!!');

      } else {
        if (mounted) {
          showSnackBarMessage(context, response.errorMessage ??
              'Set password failed..please try again!!');
        }
      }


    }
    
  }

  void  _onTapSignInButton(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SignInScreen()),
            (route) => false
    );
  }
  
  void _clearTextFields() {
    _passwordTEController.clear();
    _confirmPasswordEController.clear();
  }

  @override
  void dispose(){


    _passwordTEController.dispose();
    _confirmPasswordEController.dispose();
    super.dispose();

  }

}