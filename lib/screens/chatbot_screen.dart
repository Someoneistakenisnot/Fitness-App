import 'dart:async'; // For handling asynchronous operations and timers
import 'dart:math'; // For generating random numbers

import 'package:flutter/material.dart'; // Flutter material design package
import 'package:intl/intl.dart'; // For formatting dates and times

import '../models/message.dart'; // Importing Message model
import '../utilities/api_calls.dart'; // Import the ApiCalls class for API interactions
import '../utilities/firebase_calls.dart'; // Import Firebase calls utility

/// Screen for the chatbot interface
class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({Key? key}) : super(key: key);

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final List<Message> _messages = []; // List to store chat messages
  final TextEditingController _textController =
      TextEditingController(); // Controller for the text input field
  final Random _random =
      Random(); // Random number generator for various purposes
  bool _isTyping = false; // Flag to indicate if the bot is typing
  Timer? _typingTimer; // Timer for managing typing animation
  int _dotCount = 0; // Counter for the number of dots in the typing indicator

  /// Formats the timestamp for display
  String _formatTimestamp(DateTime timestamp) {
    return DateFormat('MMM d, y • HH:mm')
        .format(timestamp); // Format the timestamp
  }

  /// Handles the submission of user input
  Future<void> _handleSubmitted(String text) async {
    _textController.clear(); // Clear the text input field

    setState(() {
      // Add user message to the message list
      _messages.add(Message(
        text: text,
        isUserMessage: true, // Mark message as user message
        timestamp: DateTime.now()
            .toUtc()
            .add(const Duration(hours: 8)), // Adjust timestamp for timezone
      ));
      _isTyping = true; // Set typing flag to true
    });

    _startTypingAnimation(); // Start the typing animation

    try {
      // Call the chatbot API to get a response
      String botResponse = await ApiCalls().chatGptRequest(text);
      setState(() {
        _isTyping = false; // Set typing flag to false
        _typingTimer?.cancel(); // Cancel the typing timer
        _dotCount = 0; // Reset dot count
        // Add bot response to the message list
        _messages.add(Message(
          text: botResponse,
          isUserMessage: false, // Mark message as bot message
          timestamp: DateTime.now()
              .toUtc()
              .add(const Duration(hours: 8)), // Adjust timestamp for timezone
        ));
      });
    } catch (e) {
      // Handle any errors during API call
      setState(() {
        _isTyping = false; // Set typing flag to false
        _typingTimer?.cancel(); // Cancel the typing timer
        _dotCount = 0; // Reset dot count
        // Add error message to the message list
        _messages.add(Message(
          text:
              'Sorry, I could not understand that. Please try again.', // Error message
          isUserMessage: false, // Mark message as bot message
          timestamp: DateTime.now()
              .toUtc()
              .add(const Duration(hours: 8)), // Adjust timestamp for timezone
        ));
      });
    }
  }

  /// Starts the typing animation for the bot
  void _startTypingAnimation() {
    _typingTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _dotCount =
            (_dotCount + 1) % 4; // Cycle through dot count for animation
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fitness Bot', // Title of the app bar
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Text color
          ),
        ),
        backgroundColor: Colors.teal, // App bar background color
        elevation: 0, // No shadow
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back, color: Colors.white), // Back button
          onPressed: () => Navigator.pop(context), // Navigate back
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, // Gradient start
                  end: Alignment.bottomCenter, // Gradient end
                  colors: [
                    Colors.grey.shade100,
                    Colors.grey.shade100
                  ], // Gradient colors
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0), // Padding for the list
                reverse: false, // Do not reverse the list
                itemCount: _messages.length +
                    (_isTyping ? 1 : 0), // Include typing indicator if active
                itemBuilder: (context, index) {
                  if (_isTyping && index == _messages.length) {
                    return _buildTypingIndicator(); // Show typing indicator
                  } else {
                    return _buildMessageBubble(
                        _messages[index]); // Show message bubble
                  }
                },
              ),
            ),
          ),
          SafeArea(
            child: _buildTextComposer(), // Input field for composing messages
          ),
        ],
      ),
    );
  }

  /// Builds a message bubble for displaying messages
  Widget _buildMessageBubble(Message message) {
    return Align(
      alignment: message.isUserMessage
          ? Alignment.centerRight
          : Alignment.centerLeft, // Align based on message type
      child: Container(
        margin: const EdgeInsets.symmetric(
            vertical: 8.0, horizontal: 16.0), // Margin around the bubble
        padding: const EdgeInsets.all(16.0), // Padding inside the bubble
        decoration: BoxDecoration(
          color: message.isUserMessage
              ? Colors.teal.shade400
              : Colors.white, // Background color based on sender
          borderRadius: BorderRadius.circular(20), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey, // Shadow color
              spreadRadius: 1, // Spread radius
              blurRadius: 3, // Blur radius
              offset: const Offset(0, 3), // Shadow offset
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: message.isUserMessage
              ? CrossAxisAlignment.end // Align text based on sender
              : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Minimum size for the bubble
          children: [
            Text(
              message.isUserMessage
                  ? auth.currentUser?.displayName ??
                      'You' // Display user name or default
                  : 'Fitness Bot', // Display bot name
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: message.isUserMessage
                    ? Colors.white
                    : Colors.teal.shade600, // Text color based on sender
              ),
            ),
            const SizedBox(height: 8), // Space between name and message
            Text(
              message.text, // Display message text
              style: TextStyle(
                fontSize: 16,
                color: message.isUserMessage
                    ? Colors.white
                    : Colors.black, // Text color based on sender
              ),
            ),
            const SizedBox(height: 8), // Space between message and timestamp
            Text(
              _formatTimestamp(
                  message.timestamp), // Display formatted timestamp
              style: TextStyle(
                fontSize: 10,
                color: message.isUserMessage
                    ? Colors.white
                    : Colors.black, // Timestamp color based on sender
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a typing indicator to show when the bot is responding
  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft, // Align typing indicator to the left
      child: Container(
        margin: const EdgeInsets.symmetric(
            vertical: 8.0, horizontal: 16.0), // Margin around the indicator
        padding: const EdgeInsets.all(16.0), // Padding inside the indicator
        decoration: BoxDecoration(
          color: Colors.grey.shade200, // Background color for typing indicator
          borderRadius: BorderRadius.circular(20), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey, // Shadow color
              spreadRadius: 1, // Spread radius
              blurRadius: 5, // Blur radius
              offset: const Offset(0, 2), // Shadow offset
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Minimum size for the row
          children: [
            Text(
              'Fitness Bot is typing', // Typing indicator text
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600, // Text color
                fontStyle: FontStyle.italic, // Italic style
              ),
            ),
            const SizedBox(width: 8), // Space between text and dots
            SizedBox(
              width: 24, // Fixed width for dots
              child: AnimatedSwitcher(
                duration:
                    const Duration(milliseconds: 500), // Animation duration
                child: Text(
                  '.' * _dotCount, // Display dots based on count
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600, // Dot color
                    fontWeight: FontWeight.bold, // Bold style for dots
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the text composer for user input
  Widget _buildTextComposer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          16.0, 8.0, 16.0, 16.0), // Padding for the input area
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Background color for the input area
          borderRadius: BorderRadius.circular(30), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // Shadow color with opacity
              spreadRadius: 1, // Spread radius for shadow
              blurRadius: 5, // Blur radius for shadow
              offset: const Offset(0, 3), // Shadow offset
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController, // Controller for the text field
                onSubmitted: _handleSubmitted, // Handle submission of text
                style: const TextStyle(color: Colors.black), // Text color
                decoration: InputDecoration(
                  hintText:
                      'Ask about fitness, health, or nutrition...', // Placeholder text
                  border: InputBorder.none, // No border for the text field
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24), // Padding inside the text field
                  hintStyle: TextStyle(
                      color: Colors.grey.shade600), // Style for hint text
                ),
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.only(right: 1), // Margin for the send button
              decoration: BoxDecoration(
                color: Colors.teal, // Background color for the send button
                shape: BoxShape.circle, // Circular shape for the button
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white), // Send icon
                onPressed: () => _handleSubmitted(
                    _textController.text), // Handle send action
              ),
            ),
          ],
        ),
      ),
    );
  }
}
