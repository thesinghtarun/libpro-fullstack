import 'package:flutter/material.dart';
import 'package:libpro/pages/common/authentication/login_screen.dart';
import 'package:libpro/provider/app_controller.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppController(),
      child: const MaterialApp(
        home: LoginScreen(),
      ),
    );
  }
}
