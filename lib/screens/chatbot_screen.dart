import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/message.dart';
import '../utilities/firebase_calls.dart'; // Import Firebase authentication utilities

/// Chatbot screen for handling multi-topic conversations
class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({Key? key}) : super(key: key);

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

/// State class managing chatbot interactions and UI components
class _ChatBotScreenState extends State<ChatBotScreen> {
  final List<Message> _messages = []; // Stores chat history
  final TextEditingController _textController =
      TextEditingController(); // Manages text input

  /// Formats timestamp to 'Month day, year • HH:mm' format
  String _formatTimestamp(DateTime timestamp) {
    return DateFormat('MMM d, y • HH:mm').format(timestamp);
  }

  /// Handles message submission and bot response generation
  void _handleSubmitted(String text) {
    _textController.clear(); // Clear input field

    // Add user message to chat history
    setState(() {
      _messages.add(Message(
        text: text,
        isUserMessage: true,
        timestamp: DateTime.now()
            .toUtc()
            .add(const Duration(hours: 8)), // GMT+08:00 time
      ));
    });

    // Simulate bot response after 1 second delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add(Message(
          text: _getBotResponse(text),
          isUserMessage: false,
          timestamp: DateTime.now().toUtc().add(const Duration(hours: 8)),
        ));
      });
    });
  }

  /// Generates context-aware responses based on user input
  String _getBotResponse(String userMessage) {
    final message = userMessage.toLowerCase();

    // Fitness and health conversation logic
    if (message.contains('fitness') || message.contains('health')) {
      if (message.contains('nutrition') || message.contains('diet')) {
        return 'Nutrition is crucial for overall health. Are you looking for meal plans or tips on healthy eating?';
      } else if (message.contains('exercise') || message.contains('workout')) {
        return 'Exercise is vital for maintaining fitness. What type of workouts do you enjoy? Cardio, strength training, or something else?';
      } else if (message.contains('mental health') ||
          message.contains('stress')) {
        return 'Mental health is just as important as physical health. Do you practice any stress management techniques?';
      } else if (message.contains('weight loss') ||
          message.contains('lose weight')) {
        return 'Weight management requires a combination of diet and exercise. What are your current goals?';
      } else if (message.contains('muscle gain') ||
          message.contains('gain weight')) {
        return 'Muscle growth needs proper training and nutrition. Are you following a specific workout routine?';
      } else {
        return 'Fitness and health are essential. What specific aspect interests you?';
      }
    }

    // Technology improvements conversation logic
    else if (message.contains('tech') || message.contains('technology')) {
      if (message.contains('innovation') || message.contains('trends')) {
        return 'Technology evolves rapidly! Any specific innovations or trends you’re excited about?';
      } else if (message.contains('gadgets') || message.contains('devices')) {
        return 'Many cool gadgets exist! What type of devices interest you?';
      } else {
        return 'What specific area of tech improvements are you curious about?';
      }
    }

    // Weather-related conversation logic
    else if (message.contains('weather') || message.contains('forecast')) {
      if (message.contains('today') || message.contains('now')) {
        return 'For real-time weather updates, please check a reliable weather website or app for the latest information!';
      } else if (message.contains('climate change')) {
        return 'Climate change is a pressing issue. What are your thoughts on its impact on weather patterns?';
      } else {
        return 'What specific weather information are you looking for?';
      }
    }

    // Artificial intelligence conversation logic
    else if (message.contains('artificial intelligence') ||
        message.contains('ai')) {
      if (message.contains('machine learning') ||
          message.contains('deep learning')) {
        return 'Machine learning and deep learning are fascinating areas of AI. Are you interested in their workings or real-life applications?';
      } else if (message.contains('applications') || message.contains('uses')) {
        return 'AI is transforming many industries. Which industry interests you most regarding AI applications?';
      } else {
        return 'Artificial intelligence is broad. What specific aspect interests you the most?';
      }
    }

    // Gaming conversation logic
    else if (message.contains('gaming') || message.contains('game')) {
      if (message.contains('favorite') || message.contains('best')) {
        return 'There are many great games! What are some of your favorites or preferred genres?';
      } else if (message.contains('trends') || message.contains('news')) {
        return 'The gaming industry is always evolving. Are you interested in the latest trends or news?';
      } else {
        return 'Gaming is a fun way to relax. What games do you enjoy playing?';
      }
    }

    // Coding conversation logic
    else if (message.contains('coding') || message.contains('programming')) {
      if (message.contains('language') || message.contains('languages')) {
        return 'Many programming languages exist! Which language are you currently learning or interested in?';
      } else if (message.contains('projects') ||
          message.contains('portfolio')) {
        return 'Working on projects is a great way to learn coding. What kind of projects are you working on?';
      } else {
        return 'Coding is a valuable skill! Are you learning a specific programming language or working on a project?';
      }
    }

    // Education conversation logic
    else if (message.contains('education') || message.contains('learning')) {
      if (message.contains('subjects') || message.contains('courses')) {
        return 'Education is key to personal growth. What subjects or courses interest you?';
      } else if (message.contains('online') || message.contains('resources')) {
        return 'Many online resources are available for learning. Are you looking for specific platforms or materials?';
      } else {
        return 'Education is important for personal development. What areas do you want to learn more about?';
      }
    }

    // General conversation fallback
    else {
      return 'That sounds interesting! Can you tell me more about it?';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Assistant'), // Title of the app
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: false,
              itemCount: _messages.length, // Number of messages in chat
              itemBuilder: (context, index) => _buildMessageBubble(
                  _messages[index]), // Build message bubble for each message
            ),
          ),
          _buildTextComposer(), // Input field for sending messages
        ],
      ),
    );
  }

  /// Builds the message bubble for displaying messages
  Widget _buildMessageBubble(Message message) {
    return Align(
      alignment: message.isUserMessage
          ? Alignment.centerRight
          : Alignment.centerLeft, // Align message based on sender
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: message.isUserMessage
              ? Colors.blue[200]
              : Colors.grey[300], // Different colors for user and bot messages
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: message.isUserMessage
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start, // Align text based on sender
          children: [
            // Sender name
            Text(
              message.isUserMessage
                  ? auth.currentUser?.displayName ?? 'You'
                  : 'Bot', // Display sender's name
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Text color for sender name
              ),
            ),
            const SizedBox(height: 5),
            // Message text
            Text(
              message.text,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black), // Text color for message content
            ),
            const SizedBox(height: 5),
            // Timestamp
            Text(
              _formatTimestamp(
                  message.timestamp), // Format and display the timestamp
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black, // Text color for timestamp
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the text input field for sending messages
  Widget _buildTextComposer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController, // Controller for managing text input
              onSubmitted: _handleSubmitted, // Handle message submission
              decoration: const InputDecoration(
                hintText: 'What are you thinking of today?', // Placeholder text
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send), // Send button icon
            onPressed: () => _handleSubmitted(
                _textController.text), // Send message on button press
          ),
        ],
      ),
    );
  }
}
