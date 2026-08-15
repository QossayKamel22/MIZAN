import 'package:equatable/equatable.dart';

/// Domain-layer failure types. Repositories return `Either<Failure, T>`
/// (via `dartz`) rather than throwing across layers, so presentation code
/// can exhaustively handle error states without try/catch sprawl
/// (docs/TECHNICAL_ARCHITECTURE.md §6).
abstract class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong on our end']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Not found']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred']);
}
