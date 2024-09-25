
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/UI/screens/authentication/reset_password_screen.dart';
import 'package:task_manager/UI/screens/authentication/sign_in_screen.dart';
import 'package:task_manager/UI/utility/app_colors.dart';
import 'package:task_manager/UI/widgets/background_widget.dart';
import 'package:task_manager/data/model/api_response.dart';
import 'package:task_manager/data/network_caller/api_call.dart';
import 'package:task_manager/ui/utility/url_list.dart';
import 'package:task_manager/ui/widgets/centered_progress_Indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';


class PinVerificationScreen extends StatefulWidget{
  const PinVerificationScreen({super.key, required this.email});

  final String email;

  @override
  State<StatefulWidget> createState() {

    return _PinVerificationScreenState();
  }

}


class _PinVerificationScreenState extends State<PinVerificationScreen>{

  final TextEditingController _pinTEController = TextEditingController();

  bool _verifyOTPInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BackgroundWidget(
          child: SafeArea(
            child: SingleChildScrollView(
                child:  Padding(padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 100,),
                      Text('Pin Verification',style: Theme.of(context).textTheme.titleLarge,),
                      const SizedBox(height: 16,),
                      Text('A 6 digits verification pin has been sent to your email address',

                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 16,),
                      _buildPinTextField(),
                      const SizedBox(height: 16,),
                      Visibility(
                          visible: _verifyOTPInProgress == false,
                          replacement: const CenteredProgressIndicator(),
                          child:  ElevatedButton(onPressed: (){

                            _getRecoverVerifyOTP();

                          }, child: const Text('Verify')),
                      ),


                      const SizedBox(height: 36,),
                      _buildBackToSignInSection()
                    ],
                  ),
                )
            ),
          ),
        )
    );
  }

  //jehetu stateful widget tai context puro ta jurei pabe

  Widget _buildPinTextField() {
    return PinCodeTextField(
                      length: 6,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                        selectedFillColor: Colors.white,
                        inactiveColor: Colors.white,
                        selectedColor: AppColors.themeColor
                      ),
                      animationDuration: const Duration(milliseconds: 300),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: true,
                      keyboardType: TextInputType.number,
                      //errorAnimationController: errorController,
                      controller: _pinTEController,
                      appContext : context
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

  Future<void> _getRecoverVerifyOTP()async{

    _verifyOTPInProgress = true;
    if(mounted){
      setState(() {

      });
    }

    String pinCode = _pinTEController.text.trim();

    ApiResponse response =
    await ApiCall.getResponse('${UrlList.recoverVerifyOTP}/${widget.email}/$pinCode');


    _verifyOTPInProgress = false;
    if(mounted){
      setState(() {

      });
    }

    if(response.isSuccess && response.responseData['status'] == 'success'){
      if(mounted){
        _clearTextFields();
        Navigator.push(context, MaterialPageRoute(builder: (context)=>
            ResetPasswordScreen(
                    email: widget.email,pinCode: pinCode,)
        ));
        showSnackBarMessage(context, 'Verify successful');
      }
    } else{
      if(mounted){
        showSnackBarMessage(context, response.errorMessage ?? 'Verify failed!!please try again');
      }
    }

  }

  void _clearTextFields(){
    _pinTEController.clear();
  }




  void _onTapSignInButton(){
    //Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInScreen(),),);
    //Navigator.pop(context);

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SignInScreen()),
            (route) => false);

  }

//void _onTapVerifyButton(){

  //  Navigator.push(context, MaterialPageRoute(builder: (context) => const ResetPasswordScreen(),),);
//}





  @override
  void dispose(){

    _pinTEController.dispose();
    super.dispose();



  }

}