import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_manager/UI/utility/assets_path.dart';

class BackgroundWidget extends StatelessWidget{
  const BackgroundWidget({super.key, required this.child});

  final Widget child;


  @override
  Widget build(BuildContext context) {

    return Stack(
        children: [
          SvgPicture.asset(
            AssetPaths.backgroundImg,
            width: double.maxFinite,
            height: double.maxFinite,
            fit: BoxFit.cover,
          ),
          child
        ]
    );
  }

}
