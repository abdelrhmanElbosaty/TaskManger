import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manger/features/utils/common.dart';

import '../../../core/app_colors.dart';
import 'tasks_cubit.dart';
import 'tasks_state.dart';
import 'widgets/tasks_body.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocProvider(
          create: (context) => TasksCubit()..onCubitStart(),
          child: const _TasksPage(),
        ),
      ),
    );
  }
}

class _TasksPage extends StatelessWidget {
  const _TasksPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SafeArea(
          child: BlocBuilder<TasksCubit, TasksState>(
            builder: (context, state) {
              if (state is TasksLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    color: AppColors.indicatorColor,
                  ),
                );
              }
              if (state is TasksError) {
                return Center(
                  child: Text(state.message.toString()),
                );
              }
              if (state is TasksLoaded) {
                return TasksBody(taskState: state);
              }

              return const SizedBox();
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToTaskPage(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
