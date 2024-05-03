import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manger/features/domain/entities/task_entity.dart';
import 'package:task_manger/features/ui/tasks_page/tasks_cubit.dart';
import 'package:task_manger/features/ui/tasks_page/tasks_state.dart';
import 'package:task_manger/features/utils/common.dart';

import 'task_filter.dart';
import 'task_item.dart';

class TasksBody extends StatefulWidget {
  final TasksLoaded taskState;

  const TasksBody({super.key, required this.taskState});

  @override
  State<TasksBody> createState() => _TasksBodyState();
}

class _TasksBodyState extends State<TasksBody> {
  late ValueNotifier<List<Task>?> tasksValueNotifier;
  ValueNotifier<TaskFilterEnum> currentTapValueNotifier =
      ValueNotifier(TaskFilterEnum.all);

  @override
  void dispose() {
    currentTapValueNotifier.dispose();
    tasksValueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TasksCubit, TasksState>(
      listener: (context, state) {
        if (state is TasksLoaded) {
          tasksValueNotifier = ValueNotifier(state.tasks);
        }
      },
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<TasksCubit>().onCubitStart();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome!',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            ValueListenableBuilder(
              valueListenable: currentTapValueNotifier,
              builder: (context, value, child) => TaskFilter(
                onTap: (filter) {
                  currentTapValueNotifier.value = filter;
                  _filterAllList(filter, widget.taskState.tasks);
                },
                currentTap: currentTapValueNotifier.value,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ValueListenableBuilder(
              valueListenable: tasksValueNotifier,
              builder: (context, value, child) => _TaskListWidget(
                  allTask: value ?? widget.taskState.tasks ?? []),
            ),
          ],
        ),
      ),
    );
  }

  void _filterAllList(TaskFilterEnum filter, [List<Task>? values]) {
    switch (filter) {
      case TaskFilterEnum.all:
        tasksValueNotifier.value = values ?? [];
      case TaskFilterEnum.urgent:
        tasksValueNotifier.value = values
                ?.where((element) => element.status == TaskFilterEnum.urgent)
                .toList() ??
            [];
      case TaskFilterEnum.completed:
        tasksValueNotifier.value = values
                ?.where((element) => element.status == TaskFilterEnum.completed)
                .toList() ??
            [];
      case TaskFilterEnum.upcoming:
        tasksValueNotifier.value = values
                ?.where((element) => element.status == TaskFilterEnum.upcoming)
                .toList() ??
            [];
    }
  }
}

class _TaskListWidget extends StatelessWidget {
  final List<Task> allTask;

  const _TaskListWidget({required this.allTask});

  @override
  Widget build(BuildContext context) {
    if (allTask.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            'There is no Tasks',
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }
    return Expanded(
      child: ListView.builder(
        itemCount: allTask.length,
        itemBuilder: (ctx, index) => Dismissible(
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 36),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  Text(
                    'Delete',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            context.read<TasksCubit>().delete(allTask[index].id);
          },
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              bool dismiss = false;
              await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                          "Are you sure you want to delete the item"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              dismiss = true;
                              Navigator.pop(context);
                            },
                            child: const Text("Yes")),
                        TextButton(
                            onPressed: () {
                              dismiss = false;
                              Navigator.pop(context);
                            },
                            child: const Text("No")),
                      ],
                    );
                  });
              return dismiss;
            }
            return null;
          },
          key: ValueKey(allTask[index].id),
          child: InkWell(
            onTap: () {
              navigateToTaskPage(context, allTask[index]);
            },
            child: TaskItem(
              allTask[index],
            ),
          ),
        ),
      ),
    );
  }
}
