import 'package:task_manger/features/domain/entities/input/task_input.dart';
import 'package:task_manger/features/domain/entities/task_entity.dart';

abstract class TasksRepository {
  Stream<List<Task>> getTasks();
  Future<void> addNewTask(TaskInput input);
  Future<void> updateTask(TaskInput input);
  Future<void> removeTask(String id);
}
