import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_colors.dart';
import '../../domain/entities/task_entity.dart';
import '../task_page/task_page.dart';
import 'tasks_cubit.dart';
import 'tasks_state.dart';
import 'widgets/task_filter.dart';
import 'widgets/task_item.dart';

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

class _TasksPage extends StatefulWidget {
  const _TasksPage();

  @override
  State<_TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<_TasksPage> {
  ValueNotifier<TaskFilterEnum> currentTapValueNotifier =
      ValueNotifier(TaskFilterEnum.all);

  late ValueNotifier<List<Task>?> tasksValueNotifier;

  @override
  void dispose() {
    currentTapValueNotifier.dispose();
    tasksValueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SafeArea(
          child: BlocConsumer<TasksCubit, TasksState>(
            listener: (context, state) {
              if (state is TasksLoaded) {
                tasksValueNotifier = ValueNotifier(state.tasks);
              }
            },
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
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<TasksCubit>().onCubitStart();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome!',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ValueListenableBuilder(
                        valueListenable: currentTapValueNotifier,
                        builder: (context, value, child) => TaskFilter(
                          onTap: (filter) {
                            currentTapValueNotifier.value = filter;
                            _filterAllList(filter, state.tasks);
                          },
                          currentTap: currentTapValueNotifier.value,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ValueListenableBuilder(
                        valueListenable: tasksValueNotifier,
                        builder: (context, value, child) =>
                            _getTaskListWidget(value ?? state.tasks ?? []),
                      ),
                    ],
                  ),
                );
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

  Widget _getTaskListWidget(List<Task> allTask) {
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
                  Text('Delete',style: TextStyle(color: Colors.white),)
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
}
