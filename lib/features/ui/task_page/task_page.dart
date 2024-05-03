import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manger/core/app_colors.dart';
import 'package:task_manger/features/domain/entities/input/task_input.dart';
import 'package:task_manger/features/ui/task_page/task_cubit.dart';

import '../../domain/entities/task_entity.dart';
import 'task_state.dart';
import 'widgets/task_form.dart';

class TaskPage extends StatelessWidget {
  final Task? task;

  const TaskPage({super.key, this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocProvider(
          create: (context) => TaskCubit(),
          child: _TaskPage(task: task),
        ),
      ),
    );
  }
}

class _TaskPage extends StatefulWidget {
  const _TaskPage({this.task});

  final Task? task;

  @override
  State<StatefulWidget> createState() => _TaskPageState();
}

class _TaskPageState extends State<_TaskPage> {
  bool get _isTaskEditing => widget.task != null;
  TaskInput? input;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskCubit, TaskState>(
      listener: (context, state) async {
        if (state is TaskError) {
          await showDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(state.message),
              );
            },
          );
        }
        if (state is TaskAdded || state is TaskEdit) {
            Navigator.pop(context, true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _isTaskEditing ? 'Edit Task' : 'Add Task',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (input?.status != null &&
                (input?.title?.isNotEmpty ?? false) &&
                (input?.description?.isNotEmpty ?? false)) {
              if (_isTaskEditing) {
                context.read<TaskCubit>().update(input!);
              } else {
                context.read<TaskCubit>().add(input!);
              }
            }
          },
          child: const Icon(Icons.save),
        ),
        body: TaskFormWidget(
          task: widget.task,
          onChange: (input) {
            setState(() {
              this.input = input;
            });
          },
        ),
      ),
    );
  }
}
