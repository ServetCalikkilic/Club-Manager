import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';
import '../../models/task.dart';
import '../../widgets/task_card.dart';

class TaskBoardScreen extends StatefulWidget {
  const TaskBoardScreen({super.key});

  @override
  State<TaskBoardScreen> createState() => _TaskBoardScreenState();
}

class _TaskBoardScreenState extends State<TaskBoardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    });
  }

  void _showCreateTaskDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final taskProvider = Provider.of<TaskProvider>(
                context,
                listen: false,
              );
              final success = await taskProvider.createTask(
                title: titleController.text.trim(),
                description: descriptionController.text.trim(),
              );

              if (success && mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Task created'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Board'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => taskProvider.fetchTasks(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateTaskDialog,
        child: const Icon(Icons.add),
      ),
      body: taskProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTaskColumn(
                    'TODO',
                    TaskStatus.TODO,
                    taskProvider.getTasksByStatus(TaskStatus.TODO),
                    Colors.grey,
                  ),
                  const SizedBox(width: 16),
                  _buildTaskColumn(
                    'DOING',
                    TaskStatus.DOING,
                    taskProvider.getTasksByStatus(TaskStatus.DOING),
                    Colors.blue,
                  ),
                  const SizedBox(width: 16),
                  _buildTaskColumn(
                    'DONE',
                    TaskStatus.DONE,
                    taskProvider.getTasksByStatus(TaskStatus.DONE),
                    Colors.green,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTaskColumn(
    String title,
    TaskStatus status,
    List<Task> tasks,
    MaterialColor color,
  ) {
    return Container(
      width: 300,
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color.shade900,
                  ),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text('${tasks.length}'),
                  backgroundColor: color,
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...tasks.map((task) => TaskCard(task: task)),
          if (tasks.isEmpty)
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'No tasks',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
        ],
      ),
    );
  }
}
