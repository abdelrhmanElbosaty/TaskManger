class Task {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final TaskFilterEnum status;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.status,
  });
}

enum TaskFilterEnum {
  all,
  urgent,
  completed,
  upcoming;

  String get name {
    switch (this) {
      case TaskFilterEnum.all:
        return 'All';
      case TaskFilterEnum.urgent:
        return 'Urgent';
      case TaskFilterEnum.completed:
        return 'Completed';
      case TaskFilterEnum.upcoming:
        return 'Upcoming';
    }
  }
}

TaskFilterEnum? convertStringToEnum(String name) {
  if (name == 'Urgent') return TaskFilterEnum.urgent;
  if (name == 'Completed') return TaskFilterEnum.completed;
  if (name == 'Upcoming') return TaskFilterEnum.upcoming;
  if (name == 'All') return TaskFilterEnum.all;
  return null;
}
