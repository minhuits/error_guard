import 'package:error_guard/error_guard.dart';
import 'package:fpdart/fpdart.dart';

class UserProfile {
  final String name;

  UserProfile(this.name);
}

// 1. Repository layer returning Either
Either<CheckedException<String?>, UserProfile> getUser(String? id) {
  // Use manual conversion to bridge functional flow with structured exceptions
  if (id == null) {
    return Left(id.toCheckedException(
      prefix: 'Storage',
      message: (
        english: 'ID is required to fetch user',
        locale: '사용자 조회를 위해 ID가 필요합니다.',
      ),
    ));
  }

  return Right(UserProfile('GuardAdmin'));
}

// 2. Business logic using TaskEither
TaskEither<CheckedException<String?>, String> updateNickname(String? newName) {
  return TaskEither<CheckedException<String?>, String>.fromEither(
    // Explicitly provide type arguments to ensure compatibility with the return type
    newName == null || newName.isEmpty
        ? Left<CheckedException<String?>, String>(
            newName.toCheckedException(
              prefix: 'Validation',
              message: (english: 'Name cannot be empty', locale: null),
            ),
          )
        : Right<CheckedException<String?>, String>(newName),
  ).map((name) => 'Successfully updated to $name');
}

void main() async {
  print('=== Error Guard + Fpdart Integration ===\n');

  // Example 1: Handling Either
  final result = getUser(null);
  result.fold(
    (exception) => print('Error in functional flow:\n$exception'),
    (user) => print('User found: ${user.name}'),
  );

  print('\n---');

  // Example 2: Handling TaskEither
  final task = updateNickname('');
  final taskResult = await task.run();

  taskResult.match(
    (e) => print('Task Failed:\n$e'),
    (s) => print('Task Success: $s'),
  );
}