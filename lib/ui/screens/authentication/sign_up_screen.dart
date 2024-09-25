import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/UI/utility/app_colors.dart';
import 'package:task_manager/UI/widgets/background_widget.dart';
import 'package:task_manager/data/model/api_response.dart';
import 'package:task_manager/data/network_caller/api_call.dart';
import 'package:task_manager/ui/utility/app_constants.dart';
import 'package:task_manager/ui/utility/url_list.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}
class _SignUpScreenState extends State<SignUpScreen>{

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool registrationInProgress = false;
  bool _showPassword = false;

  // registration ta ki progress e ache kina

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BackgroundWidget(
          child: SafeArea(
            child: SingleChildScrollView(
                child:  Padding(padding: const EdgeInsets.all(24),
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 100,),
                        Text('Join With Us',style: Theme.of(context).textTheme.titleLarge,),
                        const SizedBox(height: 24,),
                        TextFormField(
                          // autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _emailTEController,
                          keyboardType: TextInputType.emailAddress,
                          decoration:const InputDecoration(
                              hintText: 'Email'
                          ),
                          validator: (String ? value){
                            if(value?.trim().isEmpty ?? true){
                              return 'Enter your Email';
                            }
                            if(AppConstants.emailRegExp.hasMatch(value!) == false){
                              //print('Its working!!');
                              return 'Enter your valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: _firstNameTEController,
                          decoration:const InputDecoration(
                              hintText: 'First Name'
                          ),
                          //autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (String ? value){
                            if(value?.trim().isEmpty ?? true){
                              return 'Enter your first name';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: _lastNameTEController,
                          decoration:const InputDecoration(
                              hintText: 'Last Name'
                          ),
                          validator: (String ? value){
                            if(value?.trim().isEmpty ?? true){
                              return 'Enter your last name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _mobileTEController,
                          decoration:const InputDecoration(
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
                        const SizedBox(height: 10,),
                        TextFormField(

                          //keyboardType: TextInputType.number,
                          obscureText: _showPassword == false,
                          controller: _passwordTEController,
                          decoration:InputDecoration(
                              hintText: 'Password',
                              suffixIcon: IconButton(
                                  onPressed:(){
                                    _showPassword = !_showPassword;  //false = true then
                                    if(mounted){
                                      setState(() {

                                      });
                                    }},
                                  icon: Icon(_showPassword ? Icons.remove_red_eye : Icons.visibility_off)
                              )
                          ),
                          validator: (String ? value){
                            if(value?.trim().isEmpty ?? true){
                              return 'Enter your password';
                            }
                           if(AppConstants.passwordRegExp.hasMatch(value!)== false){
                             return "Must contain 8 characters, one uppercase and lowercase\n letter, a number, and a symbol.";
                           }
                            return null;
                          },
                        ),
                        const SizedBox(height: 25,),
                        Visibility(
                          visible: registrationInProgress == false,
                          replacement: const Center(
                            child: CircularProgressIndicator(),
                          ),
                          child:  ElevatedButton(onPressed: (){

                            if(_formKey.currentState!.validate()){
                                  //TODO: Call registration api

                              _registerUser();

                            }

                          }, child: const Icon(Icons.arrow_circle_right_outlined)),),

                        const SizedBox(height: 36,),
                        _buildBackToSignInSection()
                      ],
                    ),
                  ),

                )
            ),
          ),
        )
    );
  }

  Widget _buildBackToSignInSection() {
    return Center(
        child:
        RichText(text: TextSpan(
          style: TextStyle(
              color: Colors.black..withOpacity(0.9),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4
          ),
          text: "Have account ? ",
          children:  [
            TextSpan(
                text: 'Sign In',
                style: const TextStyle(
                    color: AppColors.themeColor
                ),
                recognizer: TapGestureRecognizer()..onTap =() {
                  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInScreen()),);

                  _onTapSignInButton();
                }
            ),],
        ),)
    );
  }

  void _onTapSignInButton() {
    Navigator.pop(context);
  }


  Future<void> _registerUser() async {

    if (mounted) {
      setState(() {
        registrationInProgress = true;
      });
    }

    Map<String, String> userRegInfo = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
      "password": _passwordTEController.text,
      "photo": "",
    };

    ApiResponse serverResponse =
    await ApiCall.postResponse(UrlList.registrationURL, userRegInfo);

    if (serverResponse.isSuccess && mounted) {
      setState(() {
        registrationInProgress = false;
      });
      showSnackBarMessage(context, 'Registration Successful');

      await Future.delayed(const Duration(seconds: 1));
      if(mounted) {
        Navigator.pop(context);
      }
    }
    else {
      if (mounted) {
        showSnackBarMessage(context, 'Registration failed!! please try again');
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          registrationInProgress = false;
        });
      }
    }
  }

  @override
  void dispose() {

    _emailTEController.dispose();
    _passwordTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    super.dispose();
  }
}