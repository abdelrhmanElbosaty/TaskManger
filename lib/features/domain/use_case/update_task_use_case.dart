import 'package:task_manger/features/domain/entities/input/task_input.dart';

import '../repositories/tasks_repository.dart';

class UpdateTaskUseCase {
  final TasksRepository repository;

  UpdateTaskUseCase(this.repository);

  Future<void> execute(TaskInput input) {
    return repository.updateTask(input);
  }
}
