import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/app_injector.dart';
import 'features/ui/home/tasks_page.dart';
import 'user_default_firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  await Firebase.initializeApp(
    name: 'TaskManger',
    options: UserDefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TasksPage(),
    );
  }
}
