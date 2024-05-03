import 'package:task_manger/features/domain/entities/task_entity.dart';

import '../repositories/tasks_repository.dart';

class GetTasksUseCase {
  final TasksRepository repository;

  GetTasksUseCase(this.repository);

  Stream<List<Task>> execute() {
    return repository.getTasks();
  }
}
