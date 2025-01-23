import 'package:database_app/screens/login_create_account_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/database_helper.dart';
import 'create_task.dart';
import '../widgets/info_card.dart';
import 'drawer.dart';

class TaskManager extends StatefulWidget {
  const TaskManager({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TaskManagerState createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Load tasks from the database
  void _loadTasks() async {
    List<Task> taskList = await _databaseHelper.getTaskList();
    setState(() {
      tasks = taskList;
    });
  }

  // Delete a task from the database
  void _deleteTask(int index) async {
    await _databaseHelper.deleteTask(tasks[index].id!);
    setState(() {
      tasks.removeAt(index);
    });
  }

  // Navigate to CreateTaskPage to add a new task
  void _addNewTask() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateTaskPage(),
      ),
    ).then((value) {
      if (value != null && value) {
        _loadTasks(); // Reload tasks after saving
      }
    });
  }

  // Navigate to CreateTaskPage to edit an existing task
  void _editTask(Task task, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateTaskPage(task: task, taskIndex: index),
      ),
    ).then((value) {
      if (value != null && value) {
        _loadTasks(); // Reload tasks after saving
      }
    });
  }

  void _navigateToLoginCreateAccountScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginCreateAccountScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return const SizedBox(width: 15); // Empty space instead of button
              } else {
                return OutlinedButton(
                  onPressed: () => _navigateToLoginCreateAccountScreen(context),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),
                    side: BorderSide(color: Colors.purple.shade300, width: 1),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.purple.shade300,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }
            },
          ),
          const SizedBox(width: 15)
        ],
      ),
      drawer: CustomDrawer(
        username: 'Sakib Anjum Arnab',
        email: 'arnab@example.com',
        profilePictureUrl: 'https://www.example.com/profile-picture.jpg',
        isBackupEnabled: false,
        onBackupToggle: (bool value) {
          // Handle backup toggle functionality here
        },
        onLogout: () {
          // Handle logout functionality here
        },
        onExit: () {
          // Handle exit functionality here
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: tasks.isEmpty ? 1 : tasks.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 5 / 5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            if (tasks.isEmpty) {
              // Show default InfoCard when no tasks are available
              return GestureDetector(
                onTap: () => _addNewTask(),
                child: InfoCard(
                  task: Task(
                    id: 0,
                    title: 'Welcome to task manager',
                    description: 'Add your tasks.',
                    timeAndDate: '',
                    priority: '',
                    isChecked: false,
                  ),
                  onCheckboxChanged: null, // No checkbox action for default card
                  onDelete: null, // No delete action for default card
                ),
              );
            }
            final task = tasks[index];
            return Opacity(
              opacity: task.isChecked ? 0.5 : 1.0,
              child: GestureDetector(
                onTap: () => _editTask(task, index),
                child: InfoCard(
                  task: task,
                  onCheckboxChanged: (value) {
                    setState(() {
                      task.isChecked = value ?? false;
                    });
                  },
                  onDelete: () => _deleteTask(index),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTask,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(
            color: Colors.purple.shade300,
            width: 2,
          ),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.purple,
        ),
      ),
    );
  }
}
