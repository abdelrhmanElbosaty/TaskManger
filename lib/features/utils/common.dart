import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manger/features/domain/entities/task_entity.dart';
import 'package:task_manger/features/ui/task_page/task_page.dart';
import 'package:task_manger/features/ui/tasks_page/tasks_cubit.dart';

void navigateToTaskPage(BuildContext context, [Task? task]) {
  Navigator.of(context).push<bool>(
    MaterialPageRoute(
      builder: (ctx) {
        return TaskPage(task: task);
      },
    ),
  ).then(
    (value) {
      if (value == true) {
        context.read<TasksCubit>().onCubitStart();
      }
    },
  );
}
