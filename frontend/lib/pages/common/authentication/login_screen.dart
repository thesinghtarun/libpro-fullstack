import 'package:flutter/material.dart';
import 'package:libpro/pages/common/authentication/forgot_password_screen.dart';
import 'package:libpro/pages/common/authentication/register_screen.dart';
import 'package:libpro/pages/common/home_screen.dart';
import 'package:libpro/provider/app_controller.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  "assets/images/meeting.png",
                  height: 150,
                  width: 300,
                ),
                const Text(
                  "Welcome",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
                ),
                const SizedBox(height: 5),
                const Text(
                  "By login you are agreeing our",
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Terms and Privacy Policy",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: const Icon(Icons.email),
                    hintText: "Email",
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: const Icon(Icons.lock),
                    hintText: "Password",
                  ),
                  // obscureText: true,
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ForgotPasswordScreen(),
                      ),
                    ),
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Consumer<AppController>(
                  builder: (context, value, child) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          value.login(
                              emailController.text.toString().trim(),
                              passwordController.text.toString().trim(),
                              context);
                        },
                        child: const Text("Login"),
                      ),
                      OutlinedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        ),
                        child: const Text("Register"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
