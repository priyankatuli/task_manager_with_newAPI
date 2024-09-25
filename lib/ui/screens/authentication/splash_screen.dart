import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_manager/UI/screens/authentication/sign_in_screen.dart';
import 'package:task_manager/UI/screens/main_bottom_navigation_bar.dart';

import 'package:task_manager/UI/utility/assets_path.dart';
import 'package:task_manager/UI/widgets/background_widget.dart';
import 'package:task_manager/ui/controllers/authentication_controller.dart';



class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return  _SplashScreenState();
  }

}

class _SplashScreenState extends State<SplashScreen> {
  @override


  void initState(){
    super.initState();
    _moveToNextScreen();

  }


  Future<void> _moveToNextScreen() async{
    await Future.delayed(const Duration(seconds: 2));
    bool isUserLoggedIn = await AuthenticationController.checkIfUserLoggedInOrNot();

    if(mounted) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) =>
          isUserLoggedIn ? const MainBottomNavigationBar() : const SignInScreen()));
    }

    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BackgroundWidget(
          child: Center(
            child: SvgPicture.asset(
              AssetPaths.logoImg,
              width: MediaQuery.sizeOf(context).width / 1.7,
            ),
          ),
        )

    );
  }
}