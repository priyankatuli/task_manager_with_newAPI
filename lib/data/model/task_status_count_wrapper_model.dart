import 'package:task_manager/data/model/task_status_count_model.dart';

class TaskStatusCountWrapperModel {
  String? status;
  List<TaskStatusCountModel>? taskCount;

  TaskStatusCountWrapperModel({this.status, this.taskCount});

  TaskStatusCountWrapperModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      taskCount = <TaskStatusCountModel>[];
      json['data'].forEach((v) {
        taskCount!.add(TaskStatusCountModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (taskCount != null) {
      data['data'] = taskCount!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

