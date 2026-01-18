import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              task.description,
              style: TextStyle(color: Colors.grey[700]),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            _buildStatusButtons(context, taskProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButtons(BuildContext context, TaskProvider taskProvider) {
    final statusButtons = <Widget>[];

    if (task.status != TaskStatus.TODO) {
      statusButtons.add(
        Expanded(
          child: OutlinedButton(
            onPressed: () =>
                _updateStatus(context, taskProvider, TaskStatus.TODO),
            child: const Text('TODO', style: TextStyle(fontSize: 12)),
          ),
        ),
      );
      statusButtons.add(const SizedBox(width: 4));
    }

    if (task.status != TaskStatus.DOING) {
      statusButtons.add(
        Expanded(
          child: OutlinedButton(
            onPressed: () =>
                _updateStatus(context, taskProvider, TaskStatus.DOING),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
            child: const Text('DOING', style: TextStyle(fontSize: 12)),
          ),
        ),
      );
      statusButtons.add(const SizedBox(width: 4));
    }

    if (task.status != TaskStatus.DONE) {
      statusButtons.add(
        Expanded(
          child: OutlinedButton(
            onPressed: () =>
                _updateStatus(context, taskProvider, TaskStatus.DONE),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.green),
            child: const Text('DONE', style: TextStyle(fontSize: 12)),
          ),
        ),
      );
    }

    return Row(children: statusButtons);
  }

  Future<void> _updateStatus(
    BuildContext context,
    TaskProvider taskProvider,
    TaskStatus newStatus,
  ) async {
    final success = await taskProvider.updateTaskStatus(
      taskId: task.id,
      status: newStatus,
    );

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task moved to ${newStatus.name}'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }
}
