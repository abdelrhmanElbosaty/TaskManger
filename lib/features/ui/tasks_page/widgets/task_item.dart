import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/task_entity.dart';

class TaskItem extends StatefulWidget {
  const TaskItem(this.task, {super.key});

  final Task task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  late String contentFirstHalf;
  late String contentSecondHalf;
  bool flag = true;

  @override
  void initState() {
    _refineContent();
    super.initState();
  }

  void _refineContent() {
    if (widget.task.description.length > 100) {
      contentFirstHalf = widget.task.description.substring(0, 100);
      contentSecondHalf = widget.task.description
          .substring(100, widget.task.description.length);
    } else {
      contentFirstHalf = widget.task.description;
      contentSecondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.task.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            _buildDescription,
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    DateFormat('d MMM y, hh:mm a')
                        .format(widget.task.createdAt),
                  ),
                ),
                Flexible(
                  child: Text(
                    widget.task.status.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget get _buildDescription {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(),
      child: contentSecondHalf.isEmpty
          ? _buildNormalContent
          : _buildReadMoreContent,
    );
  }

  Widget get _buildNormalContent {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: contentFirstHalf.length > 1 ? 0 : 8, vertical: 0),
      child: Text(
        contentFirstHalf,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  Widget get _buildReadMoreContent {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            style: const TextStyle(fontSize: 16, color: Colors.black),
            children: [
              TextSpan(
                  text: flag
                      ? ("$contentFirstHalf...")
                      : (contentFirstHalf + contentSecondHalf)),
              const WidgetSpan(
                child: SizedBox(
                  width: 2,
                ),
              ),
              TextSpan(
                text: flag ? 'read more' : 'read less',
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => setState(() {
                        flag = !flag;
                      }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
