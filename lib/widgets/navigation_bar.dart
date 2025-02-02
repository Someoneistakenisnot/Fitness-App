import 'package:flutter/material.dart';

// Custom bottom navigation bar widget that handles main app navigation
class MyBottomNavigationBar extends StatefulWidget {
  MyBottomNavigationBar({Key? key, required this.selectedIndexNavBar})
      : super(key: key);

  // Tracks the currently selected navigation item index
  int selectedIndexNavBar;

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  // Handles navigation when a bottom bar item is tapped
  void _onTap(int index) {
    widget.selectedIndexNavBar = index;
    setState(() {
      // Navigate to different screens based on selected index
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/home'); // Home screen
          break;
        case 1:
          Navigator.pushReplacementNamed(
              context, '/exercise'); // Exercise screen
          break;
        case 2:
          Navigator.pushReplacementNamed(
              context, '/user'); // User profile screen
          break;
        case 3:
          Navigator.pushReplacementNamed(context, '/game'); // Game screen
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // Visual styling properties
      backgroundColor: Colors.white, // Background color of the navigation bar
      selectedItemColor: Colors.blue, // Color for selected navigation item
      unselectedItemColor: Colors.grey, // Color for unselected items

      // Navigation items configuration
      items: const [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home), // Home icon
        ),
        BottomNavigationBarItem(
          label: 'Exercise',
          icon: Icon(Icons.directions_run), // Exercise icon
        ),
        BottomNavigationBarItem(
          label: 'User',
          icon: Icon(Icons.person), // User profile icon
        ),
        BottomNavigationBarItem(
          label: 'Game',
          icon: Icon(Icons.gamepad_outlined), // Game controller icon
        ),
      ],
      // Current selected index management
      currentIndex: widget.selectedIndexNavBar,
      onTap: _onTap, // Tap handler for navigation
    );
  }
}
