import '../repositories/tasks_repository.dart';

class DeleteTaskUseCase {
  final TasksRepository repository;

  DeleteTaskUseCase(this.repository);

  Future<void> execute(String id) {
    return repository.removeTask(id);
  }
}
