import 'package:task_manger/features/data/models/api_tasks_result.dart';
import 'package:task_manger/features/domain/entities/task_entity.dart';

extension ConvertApiCartsResult on ApiTask {
  Task get mapTask {
    return Task(
        id: documentId ?? '',
        createdAt: _convert,
        title: title ?? '',
        status: convertStringToEnum(type ?? '') ?? TaskFilterEnum.all,
        description: description ?? '');
  }

  DateTime get _convert {
    return DateTime.parse(createdAt ?? '');
  }
}
