import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/UI/screens/authentication/sign_up_screen.dart';
import 'package:task_manager/UI/screens/main_bottom_navigation_bar.dart';
import 'package:task_manager/UI/utility/app_colors.dart';
import 'package:task_manager/UI/widgets/background_widget.dart';
import 'package:task_manager/data/model/api_response.dart';
import 'package:task_manager/data/model/log_in_model.dart';
import 'package:task_manager/data/network_caller/api_call.dart';
import 'package:task_manager/ui/controllers/authentication_controller.dart';
import 'package:task_manager/ui/screens/authentication/email_verification_screen.dart';
import 'package:task_manager/ui/utility/app_constants.dart';
import 'package:task_manager/ui/utility/url_list.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool signInProgress = false;
   bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100),
                    Text(
                      'Get Started With',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _emailTEController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: 'Email'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your email address';
                        }
                        if (AppConstants.emailRegExp.hasMatch(value!) ==
                            false) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      obscureText: _showPassword==false,
                      controller: _passwordTEController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        suffixIcon: IconButton(onPressed: (){
                          _showPassword =! _showPassword;
                          if(mounted){
                            setState(() {
                            });
                          }
                          },
                          icon: Icon(_showPassword ? Icons.remove_red_eye: Icons.visibility_off),)
                      ),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your password';
                        }
                        if(AppConstants.passwordRegExp.hasMatch(value!) == false){
                          return "Must contain 8 characters, one uppercase and lowercase\n letter, a number, and a symbol.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Visibility(
                      visible: signInProgress == false,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: ElevatedButton(
                        onPressed: _onTapNextButton,
                        child: const Icon(Icons.arrow_circle_right_outlined),
                      ),
                    ),
                    const SizedBox(height: 36),
                    Center(
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: _onTapForgotPasswordButton,
                            child: const Text('Forgot Password?'),
                          ),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.4,
                              ),
                              text: "Don't have an account? ",
                              children: [
                                TextSpan(
                                  text: 'Sign up',
                                  style: const TextStyle(
                                      color: AppColors.themeColor),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _onTapSignUpButton,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onTapNextButton() async {
    if (_formKey.currentState!.validate()) {
      await signInServer();
    }
  }

  Future<void> signInServer() async {
    setState(() {
      signInProgress = true;
    });
    
    final Map<String, String> userSignInData = {
      "email": _emailTEController.text.trim(),
      "password": _passwordTEController.text
    };

    ApiResponse getServerResponse =
    await ApiCall.postResponse(UrlList.logInURL, userSignInData);
    if (getServerResponse.isSuccess == true) {

        LogInModel logInModel = LogInModel.fromJson(getServerResponse.responseData);
        await AuthenticationController.saveLogInToken(logInModel.token!);
        await AuthenticationController.saveUserData(logInModel.data!);

        if(mounted) {
          showSnackBarMessage(context, 'Sign in Successful');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainBottomNavigationBar(),
            ),
          );
        }

      }
     else {
      if (mounted) {
        showSnackBarMessage(context, 'Sign in failed!! please try again.');

        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          signInProgress = false;
        });
      }
    }
  }

  void _onTapForgotPasswordButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EmailVerificationScreen(),
      ),
    );
  }

  void _onTapSignUpButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }



  @override
  void dispose() {

    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}