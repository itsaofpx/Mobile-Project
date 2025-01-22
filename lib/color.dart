import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LuckyColor extends StatelessWidget {
  const LuckyColor({super.key});
  Color dayToColor(String day) {
    switch (day) {
      case "Monday":
        return Colors.yellow;
      case "Tuesday":
        return Colors.pink;
      case "Wednesday":
        return Colors.green;
      case "Thursday":
        return Colors.orange;
      case "Friday":
        return Colors.blue;
      case "Saturday":
        return Colors.purple;
      default:
        return Colors.red;
    }
  }

  String colorToName(Color color) {
    if (color == Colors.yellow) return "yellow";
    if (color == Colors.pink) return "pink";
    if (color == Colors.green) return "green";
    if (color == Colors.orange) return "orange";
    if (color == Colors.blue) return "blue";
    if (color == Colors.purple) return "purple";
    return "Red"; // Default color name
  }

  @override
  Widget build(BuildContext context) {
    String now =
        DateFormat.EEEE().format(DateTime.now()); // Get the current day
    Color luckyColor = dayToColor(now);
    String luckyColorName = colorToName(luckyColor); // Get the color name

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Color',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 36, 93),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              //  Navigator.pushNamed(context ,'/list');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              height: 400,
              width: 300,
              decoration: BoxDecoration(
                  color: luckyColor, // Apply the color here
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: AssetImage(
                          // 'assets/images/luckycolor/blue.png'),
                          'assets/images/luckycolor/$luckyColorName.png'),
                      fit: BoxFit.cover)),
            ),
            Container(
              child: Center(
                child: Text(
                  "Today is $now.",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Center(
              child: Text.rich(
                TextSpan(
                  text: "Lucky shirt color is ",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '$luckyColorName', // The part you want to make green
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: luckyColor , // Green color for luckyColorName
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
