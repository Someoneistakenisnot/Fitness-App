import 'dart:math'; // For random number generation

import 'package:flutter/material.dart';

import '../utilities/constants.dart'; // App constants
import '../utilities/firebase_calls.dart'; // Firebase authentication utilities
import '../widgets/navigation_bar.dart'; // Custom navigation bar

/// Game screen with a tap-based points collection mechanic
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Position and appearance variables
  double _top = 100; // Vertical position of the button
  double _left = 100; // Horizontal position of the button
  double _size = 100; // Size of the button
  Color _color = Colors.blue; // Color of the button
  int _points = 10; // Points awarded per tap (based on size)
  int _totalPoints = 0; // Cumulative points counter

  @override
  void initState() {
    super.initState();
    _updatePoints(); // Initialize points based on starting size
  }

  /// Updates points value based on current button size
  void _updatePoints() {
    _points = (_size / 10).round(); // Smaller buttons give more points
  }

  /// Moves button to random position and changes appearance
  void _moveButton() {
    final random = Random();
    setState(() {
      // Calculate new position within screen bounds
      _top = random.nextDouble() *
              (MediaQuery.of(context).size.height * 0.65 - _size - 50) +
          10; // Account for button size and margins
      _left = random.nextDouble() *
              (MediaQuery.of(context).size.width - _size - 50) +
          10;

      // Generate new random size (65-225 pixels)
      _size = (random.nextDouble() * 150 + 65).clamp(40.0, 225.0);
      _color = _generateRandomColor(); // Generate new color
      _updatePoints(); // Recalculate points value
      _totalPoints += _points; // Add points to total
    });
  }

  /// Generates random color avoiding bright/white hues
  Color _generateRandomColor() {
    final random = Random();
    Color color;
    do {
      // Generate color in HSV space for better control
      final hue = random.nextDouble() * 360;
      final saturation = random.nextDouble() * 0.5 + 0.5; // 50-100%
      final brightness = random.nextDouble() * 0.5 + 0.5; // 50-100%

      color = HSVColor.fromAHSV(1.0, hue, saturation, brightness).toColor();
    } while (_isBrightOrPastel(color) || _isWhite(color)); // Filter colors

    return color;
  }

  /// Checks if color is too light
  bool _isBrightOrPastel(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.lightness > 0.7; // Reject colors with high lightness
  }

  /// Checks for pure white
  bool _isWhite(Color color) => color == Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Color(0xFF5E60CE).withOpacity(0.85), // AppBar color with opacity
        title: Text(
          "Games", // Title of the app
          style: kAppName, // Custom text style for the app name
        ),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut(); // Sign out the user
              Navigator.pushReplacementNamed(context, '/'); // Navigate to home
            },
            icon: Icon(
              Icons.logout, // Logout icon
              color: Colors.black,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[200], // Background color of the screen
      bottomNavigationBar: MyBottomNavigationBar(
          selectedIndexNavBar: 3), // Custom navigation bar
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 25), // Spacer
            Align(
              alignment: Alignment.centerLeft, // Align text to the left
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    15, 0, 0, 0), // Padding for the text
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Total Points: ', // Label for total points
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '$_totalPoints', // Display total points
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 25), // Spacer
            Container(
              height: MediaQuery.of(context).size.height *
                  0.65, // Container height based on screen size
              decoration: BoxDecoration(
                color: Colors.white, // Background color of the container
                borderRadius: BorderRadius.circular(0), // No border radius
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color
                    spreadRadius: 5, // Spread radius of the shadow
                    blurRadius: 10, // Blur radius of the shadow
                    offset: Offset(0, 3), // Offset of the shadow
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: _top, // Position the button vertically
                    left: _left, // Position the button horizontally
                    child: GestureDetector(
                      onTap: () {
                        _totalPoints += _points; // Add points on tap
                        _moveButton(); // Move button to a new position
                      },
                      child: Container(
                        width: _size, // Width of the button
                        height: _size, // Height of the button
                        decoration: BoxDecoration(
                          color: _color, // Color of the button
                          borderRadius:
                              BorderRadius.circular(20), // Rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.5), // Shadow for the button
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '+$_points', // Display points awarded for the tap
                            style: TextStyle(
                              color: Colors.white, // Text color
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0, // Shadow blur for text
                                  color: Colors.black
                                      .withOpacity(0.5), // Shadow color
                                  offset: Offset(2.0, 2.0), // Shadow offset
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
