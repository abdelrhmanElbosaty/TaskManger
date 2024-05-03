import 'package:task_manger/core/app_injector.dart';
import 'package:task_manger/features/data/repositories_imp/tasks_repository_imp.dart';
import 'package:task_manger/features/domain/repositories/tasks_repository.dart';
import 'package:task_manger/features/domain/use_case/add_new_task_use_case.dart';
import 'package:task_manger/features/domain/use_case/delete_task_use_case.dart';
import 'package:task_manger/features/domain/use_case/get_tasks_use_case.dart';
import 'package:task_manger/features/domain/use_case/update_task_use_case.dart';

class TasksDi {
  TasksDi._();

  static Future<void> initialize() async {
    injector
        .registerLazySingleton<TasksRepository>(() => TasksRepositoryImpl());

    injector.registerFactory(() => GetTasksUseCase(injector()));
    injector.registerFactory(() => AddNewTaskUseCase(injector()));
    injector.registerFactory(() => DeleteTaskUseCase(injector()));
    injector.registerFactory(() => UpdateTaskUseCase(injector()));
  }
}
