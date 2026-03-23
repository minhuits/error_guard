import 'package:error_guard/error_guard.dart';

// Mock model for demonstration
class User {
  final String id;
  final String name;

  User({required this.id, required this.name});

  @override
  String toString() => 'User(id: $id, name: $name)';
}

void main() {
  print('=== Error Guard: All-in-One Comprehensive Example ===\n');

  // ---------------------------------------------------------------------------
  // 1. CheckedException (Predictable Business Logic Failures)
  // ---------------------------------------------------------------------------
  print('[Case 1] CheckedException - Validation Logic');
  try {
    const int age = 16;

    // Declarative validation: Throws if condition is met
    age.throwCheckedIf(
      (v) => v < 19,
      prefix: 'Auth',
      message: (
        english: 'Access denied: User must be 19 or older.',
        locale: '접근 거부: 19세 이상만 이용 가능합니다.'
      ),
    );
  } catch (e) {
    // Expected output: AuthException: value = 16 (int)...
    print(e);
  }

  // ---------------------------------------------------------------------------
  // 2. UncheckedError (Unpredictable System/Programmer Errors)
  // ---------------------------------------------------------------------------
  print('\n[Case 2] UncheckedError - Critical Developer Error');
  try {
    final String? apiKey = null; // Assume this MUST be provided via ENV

    // Use throwUncheckedIfNull for things that should "never" be null
    apiKey.throwUncheckedIfNull(
      prefix: 'Config',
      message: (
        english: 'API Key is missing. Check your environment variables.',
        locale: 'API 키가 누락되었습니다. 환경 변수를 확인하세요.'
      ),
    );
  } catch (e) {
    if (e is UncheckedError) {
      print(e);
      // UncheckedError automatically captures StackTrace
      print('Stacktrace is captured: ${e.stackTrace != null}');
    }
  }

  // ---------------------------------------------------------------------------
  // 3. Type Promotion (Nullable to Non-Nullable)
  // ---------------------------------------------------------------------------
  print('\n[Case 3] Type Promotion');
  try {
    final String? nullableName = 'Gemini';

    // Promotes String? to String upon success
    final String name = nullableName.throwCheckedIfNull(
      prefix: 'Data',
      message: (english: 'Name is missing', locale: null),
    );

    print('Promoted Value: $name (Type: ${name.runtimeType})');
  } catch (e) {
    print(e);
  }

  // ---------------------------------------------------------------------------
  // 4. Manual Conversion (For non-throwing flows)
  // ---------------------------------------------------------------------------
  print('\n[Case 4] Manual Conversion (No Throwing)');
  final double? score = null;

  // Convert value to exception object without throwing it
  final manualEx = score.toCheckedException(
    prefix: 'Grading',
    message: (english: 'Score cannot be null', locale: null),
  );

  print('Manual Exception Object:');
  print(manualEx); // Shows precise tracking: (Null as double?)

  // ---------------------------------------------------------------------------
  // 5. Complex Chain (throwCheckedIfOrNull)
  // ---------------------------------------------------------------------------
  print('\n[Case 5] Complex Validation & Promotion');
  try {
    const String? email = 'invalid_email';

    // Checks if null first, then checks the condition
    final validEmail = email.throwCheckedIfOrNull(
      (v) => !v.contains('@'),
      prefix: 'Validator',
      message: (english: 'Invalid email format', locale: '잘못된 이메일 형식입니다.'),
    );

    print('Email is valid: $validEmail');
  } catch (e) {
    print(e);
  }
}