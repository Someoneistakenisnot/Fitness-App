/// Represents a chat message in the conversation flow
///
/// Stores message content, origin (user/bot), and timestamp
class Message {
  /// The textual content of the message
  final String text;

  /// Flag indicating if the message was sent by the user (true) or the bot (false)
  final bool isUserMessage;

  /// Exact time when the message was created
  final DateTime timestamp;

  /// Creates a message instance with required properties
  ///
  /// [text]: The message content string
  /// [isUserMessage]: True for user-generated messages, false for bot responses
  /// [timestamp]: The exact DateTime when the message was created
  Message({
    required this.text,
    required this.isUserMessage,
    required this.timestamp,
  });
}
