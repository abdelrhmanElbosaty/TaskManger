import 'package:flutter/material.dart';
import 'package:task_manger/features/domain/entities/input/task_input.dart';
import 'package:task_manger/features/ui/task_page/widgets/text_field.dart';

import '../../../domain/entities/task_entity.dart';

class TaskFormWidget extends StatefulWidget {
  const TaskFormWidget({this.task, super.key, required this.onChange});

  final Task? task;
  final void Function(TaskInput input) onChange;

  @override
  State<StatefulWidget> createState() => _AddTaskFormWidgetState();
}

class _AddTaskFormWidgetState extends State<TaskFormWidget> {
  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _descriptionTextController =
      TextEditingController();

  final ValueNotifier<String> _selectedTaskNotifier = ValueNotifier('');

  bool get _isTaskEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    if (_isTaskEditing) {
      _selectedTaskNotifier.value = widget.task!.status.name;
      _titleTextController.text = widget.task!.title;
      _descriptionTextController.text = widget.task!.description;
    }
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _descriptionTextController.dispose();
    _selectedTaskNotifier.dispose();
    super.dispose();
  }

  void change() async {
    widget.onChange(TaskInput(
        documentId: widget.task?.id,
        title: _titleTextController.text,
        description: _descriptionTextController.text,
        status: convertStringToEnum(_selectedTaskNotifier.value)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        child: Column(
          children: [
            TextFieldWidget(
              controller: _titleTextController,
              maxLength: 100,
              label: 'Enter task title',
              onChanged: (text) {
                change();
              },
            ),
            const SizedBox(height: 18),
            TextFieldWidget(
              controller: _descriptionTextController,
              maxLength: 500,
              label: 'Enter task description',
              onChanged: (text) {
                change();
              },
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder(
              valueListenable: _selectedTaskNotifier,
              builder: (context, value, child) => DropdownButtonFormField(
                hint: const Text('Select Task Type'),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a task type';
                  }
                  return null;
                },
                value: _isTaskEditing ? value : null,
                items: [
                  for (TaskFilterEnum taskType in [
                    TaskFilterEnum.upcoming,
                    TaskFilterEnum.completed,
                    TaskFilterEnum.urgent,
                  ])
                    DropdownMenuItem(
                      value: taskType.name,
                      child: Text(taskType.name),
                    )
                ],
                onChanged: (item) {
                  _selectedTaskNotifier.value = item!;
                  change();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
