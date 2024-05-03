import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manger/core/app_injector.dart';
import 'package:task_manger/core/exceptions.dart';
import 'package:task_manger/features/domain/entities/input/task_input.dart';
import 'package:task_manger/features/domain/use_case/add_new_task_use_case.dart';
import 'package:task_manger/features/domain/use_case/update_task_use_case.dart';

import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  late AddNewTaskUseCase _addNewTaskUseCase;
  late UpdateTaskUseCase _updateTaskUseCase;

  TaskCubit() : super(TaskInitial()) {
    _loadUseCases();
  }

  static TaskCubit of(context) => BlocProvider.of(context);

  void _loadUseCases() {
    _addNewTaskUseCase = injector();
    _updateTaskUseCase = injector();
  }

  void onCubitStart() async {}

  void add(TaskInput input) {
    emit(TaskLoading());
    try {
      _addNewTaskUseCase.execute(input);
      emit(TaskAdded());
    } catch (e) {
      if (e is ApiRequestException) {
        emit(TaskError(e.errorMessage));
      }
    }
  }

  void update(TaskInput input) {
    emit(TaskLoading());
    try {
      _updateTaskUseCase.execute(input);
      emit(TaskEdit());
    } catch (e) {
      if (e is ApiRequestException) {
        emit(TaskError(e.errorMessage));
      }
    }
  }
}
