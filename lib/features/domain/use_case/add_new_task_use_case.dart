import 'package:task_manger/features/domain/entities/input/task_input.dart';

import '../repositories/tasks_repository.dart';

class AddNewTaskUseCase {
  final TasksRepository repository;

  AddNewTaskUseCase(this.repository);

  Future<void> execute(TaskInput input) {
    return repository.addNewTask(input);
  }
}
