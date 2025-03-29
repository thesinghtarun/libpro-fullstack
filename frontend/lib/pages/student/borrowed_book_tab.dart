import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:libpro/pages/common/show_all_request.dart';
import 'package:libpro/provider/app_controller.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class BorrowedBookTab extends StatefulWidget {
  const BorrowedBookTab({super.key});

  @override
  _BorrowedBookTabState createState() => _BorrowedBookTabState();
}

class _BorrowedBookTabState extends State<BorrowedBookTab> {
  late Future<List<dynamic>> _borrowedBooksFuture;

  @override
  void initState() {
    super.initState();
    final appController = Provider.of<AppController>(context, listen: false);
    _borrowedBooksFuture = appController.getReqAcceptedByStudent(
      appController.loggedInUserEmail,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: _borrowedBooksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/book_animated.png",
                  height: MediaQuery.of(context).size.height / 2,
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "No requested book found",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ],
            ));
          }

          var data = snapshot.data!;
          print("Data on screen: $data");

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              var book = data[index];
              var date = book["updatedAt"];
              var days = book['days'] ?? 0;
              var publisher = book['bookPublisher'] ?? "Unknown Publisher";

              return TimerCard(
                bookName: book['bookName'],
                acceptedDate: date,
                days: days,
                publisher: publisher,
                price: book["bookPrice"].toString(),
                edition: book["bookEdition"],
                publishedYear: book["bookPublishedYear"].toString(),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const ShowAllRequest())),
        label: const Text("All Request"),
        icon: const Icon(CupertinoIcons.book),
      ),
    );
  }
}

class TimerCard extends StatefulWidget {
  final String bookName;
  final String acceptedDate;
  final int days;
  final String publisher;
  final String price;
  final String edition;
  final String publishedYear;

  const TimerCard({
    super.key,
    required this.bookName,
    required this.acceptedDate,
    required this.days,
    required this.publisher,
    required this.price,
    required this.edition,
    required this.publishedYear,
  });

  @override
  _TimerCardState createState() => _TimerCardState();
}

class _TimerCardState extends State<TimerCard> {
  late Timer _timer;
  late Duration _timeLeft;

  @override
  void initState() {
    super.initState();
    _timeLeft = _calculateTimeLeft();

    // Use periodic updates every minute instead of every second
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        _timeLeft = _calculateTimeLeft();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Duration _calculateTimeLeft() {
    DateTime startDate = DateTime.parse(widget.acceptedDate);
    DateTime endDate = startDate.add(Duration(days: widget.days));
    DateTime now = DateTime.now();

    if (now.isAfter(endDate)) {
      return Duration.zero;
    }
    return endDate.difference(now);
  }

  /// ✅ Fixed date parsing
  String getDate() {
    try {
      DateTime dateTime = DateTime.parse(widget.acceptedDate);
      String year = dateTime.year.toString();
      String month = dateTime.month.toString().padLeft(2, '0');
      String day = dateTime.day.toString().padLeft(2, '0');
      return "$day-$month-$year";
    } catch (e) {
      return "Invalid Date";
    }
  }

  String _formatDuration(Duration duration) {
    if (duration == Duration.zero) {
      return "Time expired";
    }
    int days = duration.inDays;
    int hours = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;

    return "$days days, $hours hrs, $minutes min";
  }

  void _showDialog(BuildContext context) {
    String date = getDate();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.bookName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Accepted date: $date"),
            Text("Book Publisher: ${widget.publisher}"),
            Text("Book Price: ${widget.price}"),
            Text("Book Edition: ${widget.edition}"),
            Text("Published Year: ${widget.publishedYear}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.book, color: Colors.blue),
        title: Text(
          widget.bookName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("Time left: ${_formatDuration(_timeLeft)}"),
        trailing: InkWell(
          onTap: () => _showDialog(context),
          child: const Icon(Icons.more_vert),
        ),
      ),
    );
  }
}
