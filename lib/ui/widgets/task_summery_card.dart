import 'package:flutter/material.dart';

class TaskSummaryCard extends StatelessWidget {

  final String count;
  final String title;


  const TaskSummaryCard({
    super.key, required this.count, required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white70,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(count,style: Theme.of(context).textTheme.titleLarge),
            Text(title,style: Theme.of(context).textTheme.titleSmall,),
          ],
        ),
      ),
    );
  }
}