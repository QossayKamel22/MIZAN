import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  const AppUser({
    required this.id,
    required this.email,
    this.displayName,
    this.emailVerified = false,
  });

  /// Firebase UID — the stable external identity (docs/SECURITY_REQUIREMENTS.md §2).
  final String id;
  final String email;
  final String? displayName;
  final bool emailVerified;

  @override
  List<Object?> get props => [id, email, displayName, emailVerified];
}
