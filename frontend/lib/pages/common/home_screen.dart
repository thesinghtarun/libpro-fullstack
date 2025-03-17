import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:libpro/pages/librarian/add_book.dart';
import 'package:libpro/pages/librarian/add_student.dart';
import 'package:libpro/pages/librarian/history_tab.dart';
import 'package:libpro/pages/student/borrowed_book_tab.dart';
import 'package:libpro/pages/common/tabs/home_tab.dart';
import 'package:libpro/pages/common/tabs/profile_tab.dart';
import 'package:libpro/pages/common/tabs/search_tab.dart';
import 'package:libpro/provider/app_controller.dart';
import 'package:provider/provider.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> studentScreens = [
    const HomeTab(),
    const SearchTab(),
    const BorrowedBookTab(),
    const ProfileTab(),
  ];

  final List<Widget> librarianScreens = [
    const HomeTab(),
    const SearchTab(),
    const HistoryTab(),
    const ProfileTab(),
  ];

  final List<BarItem> studentItems = [
    BarItem(filledIcon: Icons.home, outlinedIcon: Icons.home_outlined),
    BarItem(
        filledIcon: CupertinoIcons.search_circle_fill,
        outlinedIcon: CupertinoIcons.search_circle),
    BarItem(filledIcon: CupertinoIcons.book, outlinedIcon: CupertinoIcons.book),
    BarItem(filledIcon: Icons.person, outlinedIcon: Icons.person_outline),
  ];

  final List<BarItem> librarianItems = [
    BarItem(filledIcon: Icons.home, outlinedIcon: Icons.home_outlined),
    BarItem(
        filledIcon: CupertinoIcons.search_circle_fill,
        outlinedIcon: CupertinoIcons.search_circle),
    BarItem(filledIcon: Icons.map, outlinedIcon: Icons.map_outlined),
    BarItem(filledIcon: Icons.person, outlinedIcon: Icons.person_outline),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppController>(
      builder: (context, value, child) => Scaffold(
          body: IndexedStack(
            index: value.currentIndex,
            children: value.loggedUserRole == "librarian"
                ? librarianScreens
                : studentScreens,
          ),
          bottomNavigationBar: WaterDropNavBar(
            bottomPadding: 10,
            backgroundColor: Colors.transparent,
            waterDropColor: value.day ? Colors.blueAccent : Colors.purpleAccent,
            onItemSelected: (index) => value.setIndex(index),
            selectedIndex: value.currentIndex,
            barItems: value.loggedUserRole == "Librarian"
                ? librarianItems
                : studentItems,
          ),
          floatingActionButton: Consumer<AppController>(
            builder: (context, value, child) => Visibility(
              visible: value.loggedUserRole == "Librarian" ? true : false,
              child: FloatingActionButton(
                onPressed: () => showOptionDialog(context),
                child: const Icon(Icons.add),
              ),
            ),
          )),
    );
  }

  void showOptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose an Option"),
          content: const Text("Would you like to add a Student or a Book?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const AddStudent()));
              },
              child: const Text("Student"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const AddBook()));
              },
              child: const Text("Book"),
            ),
          ],
        );
      },
    );
  }
}
