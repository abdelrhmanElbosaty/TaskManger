import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manger/core/exceptions.dart';
import 'package:task_manger/features/data/mappers/api_carts_map.dart';
import 'package:task_manger/features/domain/entities/input/task_input.dart';

import 'package:task_manger/features/domain/entities/task_entity.dart';

import '../../domain/repositories/tasks_repository.dart';
import '../models/api_tasks_result.dart';

class TasksRepositoryImpl implements TasksRepository {
  @override
  Stream<List<Task>> getTasks() async* {
    try {
      final Stream<QuerySnapshot<Map<String, dynamic>>> query =
          FirebaseFirestore.instance.collection('Notes').snapshots();
      await for (QuerySnapshot<Map<String, dynamic>> result in query) {
        final results = result.docs.map((docSnap) {
          return ApiTask.fromJson(docSnap.data(), docSnap.id);
        }).toList();
        yield results.map((e) => e.mapTask).toList();
      }
    } catch (error) {
      throw ApiRequestException(400, 'Failed to get tasks');
    }
  }

  @override
  Future<void> addNewTask(TaskInput input) async {
    FirebaseFirestore.instance.collection('Notes').add({
      "title": input.title,
      "content": input.description,
      "type": input.status?.name,
      "created_at": DateTime.now().toString()
    }).then((value) {
      return;
    }).catchError((error) {
      throw ApiRequestException(400, 'Failed to add new task');
    });
  }

  @override
  Future<void> updateTask(TaskInput input) async {
    FirebaseFirestore.instance
        .collection('Notes')
        .doc(input.documentId)
        .update({
      "title": input.title,
      "content": input.description,
      "type": input.status?.name,
    }).then((value) {
      return;
    }).catchError((error) {
      throw ApiRequestException(400, 'Failed to update the task');
    });
  }

  @override
  Future<void> removeTask(String id) async {
    FirebaseFirestore.instance
        .collection('Notes')
        .doc(id)
        .delete()
        .then((value) {
      return;
    }).catchError((error) {
      throw ApiRequestException(400, 'Failed to remove task');
    });
  }
}
