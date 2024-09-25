
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/UI/utility/app_colors.dart';
import 'package:task_manager/UI/widgets/background_widget.dart';
import 'package:task_manager/data/model/api_response.dart';
import 'package:task_manager/data/network_caller/api_call.dart';
import 'package:task_manager/ui/screens/authentication/pin_verification_screen.dart';
import 'package:task_manager/ui/utility/app_constants.dart';
import 'package:task_manager/ui/utility/url_list.dart';
import 'package:task_manager/ui/widgets/centered_progress_Indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';


class EmailVerificationScreen extends StatefulWidget{
  const EmailVerificationScreen({super.key});

  @override
  State<StatefulWidget> createState() {

    return _EmailVerificationScreenState();
  }

}


class _EmailVerificationScreenState extends State<EmailVerificationScreen>{

  final TextEditingController _emailTEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _sendOtpToEmailInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BackgroundWidget(
          child: SafeArea(
            child: SingleChildScrollView(
                child:  Padding(padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 100,),
                        Text('Your Email Address',style: Theme.of(context).textTheme.titleLarge,),
                        const SizedBox(height: 16,),
                        Text('A 6 digits verification pin will be sent to your email address',

                        style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 16,),
                        TextFormField(
                          controller: _emailTEController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.emailAddress,
                          decoration:const InputDecoration(
                              hintText: 'Email'
                          ),
                          validator: (String ? value){
                            if(value?.trim().isEmpty ?? true){
                              return 'Enter email address';
                            }
                            if(AppConstants.emailRegExp.hasMatch(value!) == false){
                              //print('Its working!!');
                              return 'Write your valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16,),
                        Visibility(
                            visible: _sendOtpToEmailInProgress == false,
                            replacement: const CenteredProgressIndicator(),
                            child: ElevatedButton(onPressed: (){
                              //_onTapConfirmButton();
                               if(_formKey.currentState!.validate()) {
                                 _sendVerificationEmail();
                               }
                            }, child: const Icon(Icons.arrow_circle_right_outlined)),
                        ),

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
            ),]
      )

      ),
    );
  }

  void _onTapSignInButton(){
    //Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInScreen(),),);
    Navigator.pop(context);

  }

  //void _onTapConfirmButton(){
    //Navigator.push(context, MaterialPageRoute(builder: (context) => const PinVerificationScreen(),),);
 // }


  Future<void> _sendVerificationEmail()async{

    _sendOtpToEmailInProgress = true;
    if(mounted){
      setState(() {

      });
    }

    String email = _emailTEController.text.trim();

    ApiResponse response =
    await ApiCall.getResponse('${UrlList.recoverVerifyEmail}/$email');

    _sendOtpToEmailInProgress = false;
    if(mounted){
      setState(() {

      });
    }

    if(response.isSuccess && response.responseData['status'] == 'success'){
      if(mounted){
        _clearTextFields();
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => PinVerificationScreen(email: email,),),);
        showSnackBarMessage(context, 'Pin Code is send to your email address..please check!!');
      }
    }else{
      if(mounted){
        showSnackBarMessage(context, response.errorMessage ?? 'Failed!! Something went wrong');
      }
    }

  }

void _clearTextFields(){
    _emailTEController.clear();
}

  @override
  void dispose(){


    _emailTEController.dispose();
    super.dispose();


  }

}