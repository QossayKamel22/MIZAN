import 'package:equatable/equatable.dart';

enum ChatRole { user, assistant }

class ChatMessage extends Equatable {
  const ChatMessage({required this.role, required this.text, required this.createdAt});

  final ChatRole role;
  final String text;
  final DateTime createdAt;

  @override
  List<Object?> get props => [role, text, createdAt];
}
