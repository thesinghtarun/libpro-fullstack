import 'package:flutter/material.dart';
import 'package:libpro/provider/app_controller.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 30),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/register.png",
                  height: 150,
                  width: 300,
                ),
                const Text(
                  "Librarian Registration",
                  style: TextStyle(fontSize: 24, color: Colors.grey),
                ),
                const Text(
                  "Register to explore more..",
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      suffixIcon: const Icon(Icons.person),
                      hintText: "Name"),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      suffixIcon: const Icon(Icons.email),
                      hintText: "Email"),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      suffixIcon: const Icon(Icons.lock),
                      hintText: "Password"),
                ),
                const SizedBox(
                  height: 30,
                ),
                Consumer<AppController>(
                  builder: (context, value, child) => OutlinedButton(
                      onPressed: () {
                        value.signUp(
                            nameController.text.toString().trim(),
                            emailController.text.toString().trim(),
                            passwordController.text.toString().trim(),
                            context);
                        makeNull(nameController, emailController,
                            passwordController);
                      },
                      child: const Text("Register")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  makeNull(TextEditingController name, TextEditingController email,
      TextEditingController password) {
    name.text = "";
    email.text = "";
    password.text = "";
  }
}
