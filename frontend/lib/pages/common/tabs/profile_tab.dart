import 'package:flutter/material.dart';
import 'package:libpro/pages/common/authentication/login_screen.dart';
import 'package:libpro/provider/app_controller.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Consumer<AppController>(
              builder: (context, value, child) => OutlinedButton(
                  onPressed: () {
                    value.loggedInUserEmail = null;
                    value.librarianEmail = null;
                    value.loggedUserRole = null;
                    value.setIndex(0);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()));
                  },
                  child: Text("LogOut")))),
    );
  }
}
