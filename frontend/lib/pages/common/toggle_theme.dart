import 'package:flutter/material.dart';
import 'package:libpro/pages/common/const.dart';
import 'package:libpro/pages/common/home_screen.dart';
import 'package:libpro/provider/app_controller.dart';
import 'package:provider/provider.dart';

class ToggleTheme extends StatelessWidget {
  const ToggleTheme({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Consumer<AppController>(
      builder: (context, value, child) => Scaffold(
          backgroundColor:
              value.day ? dayColor : nightColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: IconButton(
                onPressed: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const HomeScreen())),
                icon: const Icon(Icons.arrow_back)),
          ),
          body: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                bottom: value.isImageVisible ? 500 : -200,
                left: width / 2 - 50,
                child: Image.asset(
                  value.day
                      ? "assets/images/sun1.png"
                      : "assets/images/moon1.png",
                  height: 100,
                  width: 100,
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onLongPress: () => value.changeTheme(),
                      child: Image.asset(
                        value.day
                            ? "assets/images/sun.png"
                            : "assets/images/moon.png",
                        height: 80,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Long press to change theme",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          color: value.day ? Colors.black : Colors.white),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
