import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:task_manger/core/app_injector.dart';
import 'package:task_manger/core/exceptions.dart';
import 'package:task_manger/features/domain/entities/task_entity.dart';
import 'package:task_manger/features/domain/use_case/delete_task_use_case.dart';
import 'package:task_manger/features/domain/use_case/get_tasks_use_case.dart';

import 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  late GetTasksUseCase _getTasksUseCase;
  late DeleteTaskUseCase _deleteTaskUseCase;

  final _compositeSubscription = CompositeSubscription();

  TasksCubit() : super(TasksInitial()) {
    _loadUseCases();
  }

  static TasksCubit of(context) => BlocProvider.of(context);

  void _loadUseCases() {
    _getTasksUseCase = injector();
    _deleteTaskUseCase = injector();
  }

  void onCubitStart() async {
    emit(TasksLoading());
    try {
      final stream = _getTasksUseCase.execute();
      _compositeSubscription.add(stream.listen((tasks) {
        final oldTasks = tasks;
        oldTasks.sort((a, b) => b.status.name.compareTo(a.status.name));

        emit(TasksLoaded(oldTasks));
      }));
    } catch (e) {
      if (e is ApiRequestException) {
        emit(TasksError(e.errorMessage));
      }
    }
  }

  void delete(String id) {
    emit(TasksLoading());
    try {
      _deleteTaskUseCase.execute(id);
      emit(TaskDeleted());
    } catch (e) {
      if (e is ApiRequestException) {
        emit(TasksError(e.errorMessage));
      }
    }
  }

  @override
  Future<void> close() {
    _compositeSubscription.dispose();
    return super.close();
  }
}
