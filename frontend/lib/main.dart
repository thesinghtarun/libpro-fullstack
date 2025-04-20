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
      child:  Consumer<AppController>(
        builder: (context, value, child) =>  MaterialApp(
          debugShowCheckedModeBanner: false,
           theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: value.themeMode,
          home: const LoginScreen(),
        ),
      ),
    );
  }
}


// 67d6b79d36293c7a1d03f492,67d5aefe20069f80562ae618,java,CS,Tarun,3rd,30,202,student1@gmail.com,pending,10,2025-03-16T11:35:57.041Z,2025-03-16T11:35:57.041Z,0