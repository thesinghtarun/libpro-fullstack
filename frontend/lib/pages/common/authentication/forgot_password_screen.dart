import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController userNameController = TextEditingController();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: userNameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    suffixIcon: const Icon(Icons.email),
                    hintText: "Enter your Email"),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                "You will get an email to reset your password",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              OutlinedButton(
                  onPressed: () {},
                  child: const Text("Send Email"))
            ],
          ),
        ),
      ),
    );
  }
}
