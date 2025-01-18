import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatefulWidget {
  MyBottomNavigationBar({Key? key, required this.selectedIndexNavBar})
      : super(key: key);
  int selectedIndexNavBar;

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  void _onTap(int index) {
    widget.selectedIndexNavBar = index;
    setState(() {
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/home');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/exercise');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/user');
          break;
        case 3:
          Navigator.pushReplacementNamed(context, '/game');
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white, // Light background color
      selectedItemColor: Colors.blue, // Color for selected item
      unselectedItemColor: Colors.grey, // Color for unselected items
      items: const [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: 'Exercise',
          icon: Icon(Icons.directions_run),
        ),
        BottomNavigationBarItem(
          label: 'User ',
          icon: Icon(Icons.person),
        ),
        BottomNavigationBarItem(
            label: 'Game', icon: Icon(Icons.gamepad_outlined)),
      ],
      currentIndex: widget.selectedIndexNavBar,
      onTap: _onTap,
    );
  }
}
