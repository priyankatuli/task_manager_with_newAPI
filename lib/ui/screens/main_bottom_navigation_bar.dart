import 'package:flutter/material.dart';
import 'package:task_manager/UI/screens/cancelled_task_screen.dart';
import 'package:task_manager/UI/screens/completed_screen.dart';
import 'package:task_manager/UI/screens/in_progress_screen.dart';
import 'package:task_manager/UI/screens/new_task_screen.dart';
import 'package:task_manager/UI/utility/app_colors.dart';
import 'package:task_manager/UI/widgets/profile_app_bar.dart';

class MainBottomNavigationBar extends StatefulWidget{
  const MainBottomNavigationBar({super.key});

  @override
  State<StatefulWidget> createState() {

    return MainBottomNavigationBarState();
  }

}

class MainBottomNavigationBarState extends State<MainBottomNavigationBar>{

  int _selectedIndex = 0;

  //to create list of screens
  final List<Widget> _screens = const [
    NewTaskScreen(),
    CompletedScreen(),
    InProgressScreen(),
    CancelledTaskScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index){
          _selectedIndex = index;
          if(mounted){
            setState(() {

            });
          }
        },
        selectedItemColor: AppColors.themeColor1,
        unselectedItemColor: Colors.purple.shade300,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon:Icon(Icons.abc),label: 'New Task'),
          BottomNavigationBarItem(icon:Icon(Icons.done),label: 'Completed'),
          BottomNavigationBarItem(icon:Icon(Icons.ac_unit),label: 'In Progress'),
          BottomNavigationBarItem(icon:Icon(Icons.close),label: 'Cancelled'),
        ],
      ),
    );
  }


}

