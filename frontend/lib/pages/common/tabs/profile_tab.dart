import 'dart:io';

import 'package:flutter/material.dart';
import 'package:libpro/pages/common/authentication/login_screen.dart';
import 'package:libpro/pages/common/toggle_theme.dart';
import 'package:libpro/pages/common/show_all_request.dart';
import 'package:libpro/pages/student/scan_qr_to_accpt_book.dart';
import 'package:libpro/provider/app_controller.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController userNameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
      body: Consumer<AppController>(
        builder: (context, value, child) => Padding(
          padding: const EdgeInsets.all(15),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "UserName",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                ),
                TextField(
                  controller: userNameController,
                  enabled: false,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.mail),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: value.loggedInUserData["email"].toString(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: value.loggedInUserData["password"].toString(),
                  ),
                ),
                const Text(
                  "*The password showing is encrypted you can reset your password..",
                  style: TextStyle(color: Colors.redAccent),
                ),
                const SizedBox(
                  height: 20,
                ),
                OutlinedButton(onPressed: () {}, child: const Text("Update")),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                        onPressed: () {
                          value.loggedInUserEmail = null;
                          value.librarianEmail = null;
                          value.loggedUserRole = null;
                          value.setIndex(0);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()));
                        },
                        child: const Text("LogOut")),
                    OutlinedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ToggleTheme()));
                        },
                        child: const Text("Theme")),
                  ],
                ),
                OutlinedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ShowAllRequest())),
                    child: const Text("Show All Request")),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
