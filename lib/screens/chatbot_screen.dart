import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'dart:async';
import '../models/message.dart';
import '../utilities/firebase_calls.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({Key? key}) : super(key: key);

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final List<Message> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final Random _random = Random();
  bool _isTyping = false;
  Timer? _typingTimer;
  int _dotCount = 0;

  String _formatTimestamp(DateTime timestamp) {
    return DateFormat('MMM d, y • HH:mm').format(timestamp);
  }

  void _handleSubmitted(String text) {
    _textController.clear();

    setState(() {
      _messages.add(Message(
        text: text,
        isUserMessage: true,
        timestamp: DateTime.now().toUtc().add(const Duration(hours: 8)),
      ));
      _isTyping = true;
    });

    _startTypingAnimation();

    int delayInSeconds = _random.nextInt(5) + 1;

    Future.delayed(Duration(seconds: delayInSeconds), () {
      setState(() {
        _isTyping = false;
        _typingTimer?.cancel();
        _dotCount = 0;
        _messages.add(Message(
          text: _getBotResponse(text),
          isUserMessage: false,
          timestamp: DateTime.now().toUtc().add(const Duration(hours: 8)),
        ));
      });
    });
  }

  void _startTypingAnimation() {
    _typingTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _dotCount = (_dotCount + 1) % 4;
      });
    });
  }

  String _getBotResponse(String userMessage) {
    final message = userMessage.toLowerCase();

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
    } else if (message.contains('tech') || message.contains('technology')) {
      if (message.contains('innovation') || message.contains('trends')) {
        return 'Technology evolves rapidly! Any specific innovations or trends you’re excited about?';
      } else if (message.contains('gadgets') || message.contains('devices')) {
        return 'Many cool gadgets exist! What type of devices interest you?';
      } else {
        return 'What specific area of tech improvements are you curious about?';
      }
    } else if (message.contains('weather') || message.contains('forecast')) {
      if (message.contains('today') || message.contains('now')) {
        return 'For real-time weather updates, please check a reliable weather website or app for the latest information!';
      } else if (message.contains('climate change')) {
        return 'Climate change is a pressing issue. What are your thoughts on its impact on weather patterns?';
      } else {
        return 'What specific weather information are you looking for?';
      }
    } else if (message.contains('artificial intelligence') ||
        message.contains('ai')) {
      if (message.contains('machine learning') ||
          message.contains('deep learning')) {
        return 'Machine learning and deep learning are fascinating areas of AI. Are you interested in their workings or real-life applications?';
      } else if (message.contains('applications') || message.contains('uses')) {
        return 'AI is transforming many industries. Which industry interests you most regarding AI applications?';
      } else {
        return 'Artificial intelligence is broad. What specific aspect interests you the most?';
      }
    } else if (message.contains('gaming') || message.contains('game')) {
      if (message.contains('favorite') || message.contains('best')) {
        return 'There are many great games! What are some of your favorites or preferred genres?';
      } else if (message.contains('trends') || message.contains('news')) {
        return 'The gaming industry is always evolving. Are you interested in the latest trends or news?';
      } else {
        return 'Gaming is a fun way to relax. What games do you enjoy playing?';
      }
    } else if (message.contains('coding') || message.contains('programming')) {
      if (message.contains('language') || message.contains('languages')) {
        return 'Many programming languages exist! Which language are you currently learning or interested in?';
      } else if (message.contains('projects') ||
          message.contains('portfolio')) {
        return 'Working on projects is a great way to learn coding. What kind of projects are you working on?';
      } else {
        return 'Coding is a valuable skill! Are you learning a specific programming language or working on a project?';
      }
    } else if (message.contains('education') || message.contains('learning')) {
      if (message.contains('subjects') || message.contains('courses')) {
        return 'Education is key to personal growth. What subjects or courses interest you?';
      } else if (message.contains('online') || message.contains('resources')) {
        return 'Many online resources are available for learning. Are you looking for specific platforms or materials?';
      } else {
        return 'Education is important for personal development. What areas do you want to learn more about?';
      }
    } else {
      return 'That sounds interesting! Can you tell me more about it?';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fitness Assistant',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.grey.shade100, Colors.grey.shade100],
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                reverse: false,
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isTyping && index == _messages.length) {
                    return _buildTypingIndicator();
                  } else {
                    return _buildMessageBubble(_messages[index]);
                  }
                },
              ),
            ),
          ),
          SafeArea(
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    return Align(
      alignment:
          message.isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: message.isUserMessage
              ? Colors.teal.shade400
              : Colors.grey,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: message.isUserMessage
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.isUserMessage
                  ? auth.currentUser?.displayName ?? 'You'
                  : 'Fitness Bot',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color:
                    message.isUserMessage ? Colors.white : Colors.teal.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message.text,
              style: TextStyle(
                fontSize: 16,
                color: message.isUserMessage ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _formatTimestamp(message.timestamp),
              style: TextStyle(
                fontSize: 10,
                color: message.isUserMessage
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Fitness Bot is typing',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 24,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  '.' * _dotCount,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                style: const TextStyle(color: Colors.black), // Add this line
                decoration: InputDecoration(
                  hintText: 'Ask about fitness, health, or nutrition...',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 1),
              decoration: BoxDecoration(
                color: Colors.teal,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () => _handleSubmitted(_textController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
