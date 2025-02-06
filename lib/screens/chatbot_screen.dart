import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/message.dart';
import '../utilities/api_calls.dart'; // Import the ApiCalls class
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

  Future<void> _handleSubmitted(String text) async {
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

    try {
      // Call the chatbot API
      String botResponse = await ApiCalls().chatGptRequest(text);
      setState(() {
        _isTyping = false;
        _typingTimer?.cancel();
        _dotCount = 0;
        _messages.add(Message(
          text: botResponse,
          isUserMessage: false,
          timestamp: DateTime.now().toUtc().add(const Duration(hours: 8)),
        ));
      });
    } catch (e) {
      setState(() {
        _isTyping = false;
        _typingTimer?.cancel();
        _dotCount = 0;
        _messages.add(Message(
          text: 'Sorry, I could not understand that. Please try again.',
          isUserMessage: false,
          timestamp: DateTime.now().toUtc().add(const Duration(hours: 8)),
        ));
      });
    }
  }

  void _startTypingAnimation() {
    _typingTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _dotCount = (_dotCount + 1) % 4;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fitness Bot',
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
          color: message.isUserMessage ? Colors.teal.shade400 : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 3,
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
                color: message.isUserMessage ? Colors.white : Colors.black,
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
              color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 5,
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
                style: const TextStyle(color: Colors.black),
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
