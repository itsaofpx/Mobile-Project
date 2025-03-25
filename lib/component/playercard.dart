import 'package:flutter/material.dart';
import 'dart:async';

class PlayeroftheWeek extends StatefulWidget {
  const PlayeroftheWeek({super.key});

  @override
  State<PlayeroftheWeek> createState() => _PlayeroftheWeekState();
}

class _PlayeroftheWeekState extends State<PlayeroftheWeek> {
  final List<Map<String, dynamic>> players = const [
    {
      "name": "Viktor Gyökeres",
      "team": "Sporting CP",
      "age": 26,
      "goals": 28,
      "image":
          "https://cdn.futwiz.com/assets/img/fc24/faces/67350515.png",
    },
    {
      "name": "Mohamed Salah",
      "team": "Liverpool",
      "age": 32,
      "goals": 27,
      "image":
          "https://cdn.futwiz.com/assets/img/fc24/faces/50540979.png",
    },
       {
      "name": "Kylian Mbappé",
      "team": "Real Madrid",
      "age": 26,
      "goals": 20,
      "image":
          "https://cdn.futwiz.com/assets/img/fc25/faces/117672259.png",
    },
       {
      "name": "Jude Bellingham",
      "team": "Real Madrid",
      "age": 20,
      "goals": 14,
      "image":
          "https://cdn.futwiz.com/assets/img/fc24/faces/84138451.png",
    },
    {
      "name": "Harry Kane",
      "team": "Bayern Munich",
      "age": 31,
      "goals": 21,
      "image":
          "https://cdn.futwiz.com/assets/img/fc25/faces/84088206.png",
    },
      {
      "name": "Erling Haaland",
      "team": "Manchester City",
      "age": 24,
      "goals": 21,
      "image":
          "https://cdn.futwiz.com/assets/img/fc24/faces/67347949.png",
    },
    {
      "name": "Ousmane Dembélé",
      "team": "Paris Saint-Germain",
      "age": 27,
      "goals": 21,
      "image":
          "https://cdn.futwiz.com/assets/img/fc25/faces/84117523.png",
    },
  
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      if (_currentPage < players.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10, left: 20),
            child: const Text(
              'Player of the Week',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 140,
            margin: const EdgeInsets.all(5),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 130,
                        height: 140,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                          color: Color.fromARGB(255, 245, 245, 245),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16)
                            
                          ),
                          child: Image.network(
                            player["image"],
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                          : null,
                                  strokeWidth: 2,
                                  color: const Color(0xFF091442),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.person,
                                  size: 40, // Smaller icon
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // Player details - more compact
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                player["name"],
                                style: const TextStyle(
                                  fontSize: 16, // Smaller font
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5), // Reduced spacing
                              Row(
                                children: [
                                  const Icon(
                                    Icons.sports_soccer,
                                    size: 12,
                                  ), // Smaller icon
                                  const SizedBox(width: 4), // Reduced spacing
                                  Expanded(
                                    child: Text(
                                      player["team"],
                                      style: TextStyle(
                                        fontSize: 12, // Smaller font
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5), // Reduced spacing
                              Row(
                                children: [
                                  const Icon(
                                    Icons.cake,
                                    size: 12,
                                  ), // Smaller icon
                                  const SizedBox(width: 4), // Reduced spacing
                                  Text(
                                    'Age: ${player["age"]}',
                                    style: TextStyle(
                                      fontSize: 12, // Smaller font
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8), // Reduced spacing
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ), // Smaller padding
                                decoration: BoxDecoration(
                                  color: const Color(0xFF091442),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.sports_soccer,
                                      size: 12, // Smaller icon
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 4), // Reduced spacing
                                    Text(
                                      'Goals: ${player["goals"]}',
                                      style: const TextStyle(
                                        fontSize: 12, // Smaller font
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Page indicator dots - slightly smaller
          Container(
            margin: const EdgeInsets.only(top: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                players.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 6, // Smaller dots
                  height: 6, // Smaller dots
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _currentPage == index
                            ? const Color(0xFF091442)
                            : Colors.grey.shade300,
                  ),
                ),
              ),
            ),
          ),
          // Footer with reduced padding
          Container(
            padding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
            child: const Text(
              '© 2025 Aofuro inc. All rights reserved.',
              style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 74, 74, 74)),
            ),
          ),
        ],
      ),
    );
  }
}
