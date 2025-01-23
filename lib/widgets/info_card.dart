import 'package:flutter/material.dart';
import '../models/task_model.dart';
import 'priority_button.dart';

class InfoCard extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?> onCheckboxChanged;
  final VoidCallback onDelete;

  const InfoCard({
    super.key,
    required this.task,
    required this.onCheckboxChanged,
    required this.onDelete,
  });

  Color getCardColor() {
    switch (task.priority.toLowerCase()) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.purple.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: getCardColor(),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Checkbox(
              value: task.isChecked,
              shape: const CircleBorder(),
              onChanged: onCheckboxChanged,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: PriorityButton(priority: task.priority),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Text(
                  task.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(task.description),
                const Spacer(),
                Text(
                  task.timeAndDate,
                  style: const TextStyle(
                    color: Colors.blueGrey, // Updated color
                    fontSize: 14,            // Adjusted font size
                    fontStyle: FontStyle.italic, // Italicized the text
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}