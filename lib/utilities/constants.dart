import 'package:flutter/material.dart'; // Import Flutter material design package

// Colors
const Color kPrimaryColor = Color(0xFF5E60CE); // Primary color used in the app
const Color kWhiteColor = Color(0xFFFFFFFF); // White color constant

// Text Styles
const TextStyle kAppName = TextStyle(
  fontSize: 22, // Font size for the app name
  fontWeight: FontWeight.bold, // Bold font weight
  color: kWhiteColor, // Color of the app name
);

const TextStyle kShowMap = TextStyle(
  fontSize: 20, // Font size for showing map text
  fontWeight: FontWeight.bold, // Bold font weight
  color: kPrimaryColor, // Color for showing map text
);

const TextStyle kWelcomeUser = TextStyle(
  fontSize: 18, // Font size for welcome message
  color: kWhiteColor, // Color for welcome message
);

const TextStyle kInfo = TextStyle(
  fontSize: 18, // Font size for informational text
  fontWeight: FontWeight.bold, // Bold font weight
  color: kWhiteColor, // Color for informational text
);

const TextStyle ktrainInfo = TextStyle(
  fontSize: 20, // Font size for training information
  fontWeight: FontWeight.bold, // Bold font weight
  color: kWhiteColor, // Color for training information
);

const TextStyle ksmallertraininfo = TextStyle(
  fontSize: 16, // Smaller font size for training info
  fontWeight: FontWeight.bold, // Bold font weight
  color: Colors.white70, // Slightly transparent white color
  shadows: [
    // Shadow effect for text
    Shadow(
      offset: Offset(2.0, 2.0), // Shadow offset
      blurRadius: 3.0, // Shadow blur radius
      color: Color.fromARGB(255, 0, 0, 0), // Shadow color (black)
    ),
  ],
);

const TextStyle kbiggertimer = TextStyle(
  fontSize: 16, // Font size for bigger timer text
  fontWeight: FontWeight.bold, // Bold font weight
  color: kWhiteColor, // Color for timer text
  shadows: [
    // Shadow effect for text
    Shadow(
      offset: Offset(2.0, 2.0), // Shadow offset
      blurRadius: 3.0, // Shadow blur radius
      color: Color.fromARGB(255, 0, 0, 0), // Shadow color (black)
    ),
  ],
);

const TextStyle ksmallerinfo = TextStyle(
  fontSize: 14, // Smaller font size for additional info
  fontWeight: FontWeight.bold, // Bold font weight
  color: Colors.white70, // Slightly transparent white color
  shadows: [
    // Shadow effect for text
    Shadow(
      offset: Offset(2.0, 2.0), // Shadow offset
      blurRadius: 3.0, // Shadow blur radius
      color: Color.fromARGB(255, 0, 0, 0), // Shadow color (black)
    ),
  ],
);

const TextStyle kShadowRed = TextStyle(
  color: Color(0xFFC60B0B), // A deep red color for emphasis
  fontSize: 18, // Font size for red shadow text
  shadows: [
    // Shadow effect for text
    Shadow(
      offset: Offset(2.0, 2.0), // Shadow offset
      blurRadius: 3.0, // Shadow blur radius
      color: Color.fromARGB(255, 0, 0, 0), // Shadow color (black)
    ),
  ],
);

const TextStyle kShadowRed2 = TextStyle(
  color: Color(0xFFFF0000), // Bright red color for emphasis
  fontSize: 20, // Font size for red shadow text
  fontWeight: FontWeight.bold, // Bold font weight
  shadows: [
    // Shadow effect for text
    Shadow(
      offset: Offset(2.0, 2.0), // Shadow offset
      blurRadius: 3.0, // Shadow blur radius
      color: Color.fromARGB(255, 0, 0, 0), // Shadow color (black)
    ),
  ],
);

const TextStyle kShadow = TextStyle(
  color: Colors.white, // White color for shadow text
  fontSize: 22, // Font size for shadow text
  fontWeight: FontWeight.bold, // Bold font weight
  shadows: [
    // Shadow effect for text
    Shadow(
      offset: Offset(2.0, 2.0), // Shadow offset
      blurRadius: 3.0, // Shadow blur radius
      color: Color.fromARGB(255, 0, 0, 0), // Shadow color (black)
    ),
  ],
);

const TextStyle kShadow2 = TextStyle(
  color: Colors.white, // White color for shadow text
  fontSize: 16, // Font size for shadow text
  shadows: [
    // Shadow effect for text
    Shadow(
      offset: Offset(2.0, 2.0), // Shadow offset
      blurRadius: 3.0, // Shadow blur radius
      color: Color.fromARGB(255, 0, 0, 0), // Shadow color (black)
    ),
  ],
);

const TextStyle kAccessible = TextStyle(
  fontSize: 16, // Font size for accessible text
  fontWeight: FontWeight.bold, // Bold font weight
  color: kWhiteColor, // Color for accessible text
);

const TextStyle kBusTitle = TextStyle(
  fontSize: 22, // Font size for bus title
  fontWeight: FontWeight.bold, // Bold font weight
  color: kWhiteColor, // Color for bus title
);

// Other constants
const double kPadding = 14.0; // Padding constant used throughout the app

// Input decoration for activity text field
const kActivityTextFieldInputDecoration = InputDecoration(
  filled: true, // Indicates that the field is filled
  fillColor: Colors.white, // Background color of the text field
  hintText: 'Enter activity name', // Placeholder text
  hintStyle: TextStyle(color: Colors.grey), // Style for placeholder text
  border: OutlineInputBorder(
    // Border style for the text field
    borderRadius: BorderRadius.all(
      Radius.circular(10.0), // Rounded corners for the border
    ),
    borderSide: BorderSide.none, // No border side
  ),
);

// Input decoration for duration text field
const kDurationTextFieldInputDecoration = InputDecoration(
  filled: true, // Indicates that the field is filled
  fillColor: Colors.white, // Background color of the text field
  hintText: 'Enter duration (in minutes)', // Placeholder text
  hintStyle: TextStyle(color: Colors.grey), // Style for placeholder text
  border: OutlineInputBorder(
    // Border style for the text field
    borderRadius: BorderRadius.all(
      Radius.circular(10.0), // Rounded corners for the border
    ),
    borderSide: BorderSide.none, // No border side
  ),
);
