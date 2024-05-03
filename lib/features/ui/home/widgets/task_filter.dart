import 'package:flutter/material.dart';
import 'package:task_manger/core/app_colors.dart';

import '../../../domain/entities/task_entity.dart';

class TaskFilter extends StatefulWidget {
  final Function(TaskFilterEnum filter) onTap;
  final TaskFilterEnum? currentTap;

  const TaskFilter({super.key, required this.onTap, this.currentTap});

  @override
  State<TaskFilter> createState() => _TaskFilterState();
}

class _TaskFilterState extends State<TaskFilter> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: TaskFilterEnum.values.map((e) => _buildWidget(e)).toList(),
      ),
    );
  }

  Widget _buildWidget(TaskFilterEnum tap) {
    return GestureDetector(
      onTap: () => widget.onTap(tap),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
            color: widget.currentTap == tap ? AppColors.thirdColor : null,
            border: Border.all(
              color: widget.currentTap == tap
                  ? AppColors.thirdColor
                  : AppColors.secondaryColor,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(35)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            tap.name,
            style: TextStyle(
                color: widget.currentTap == tap ? AppColors.white : null),
          ),
        ),
      ),
    );
  }
}
