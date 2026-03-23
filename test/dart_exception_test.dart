import 'package:error_guard/error_guard.dart';
import 'package:error_guard/src/error_base_exception.dart' show GenericCheckedException;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BaseException & createMessage Tests', () {
    test('메시지가 없을 때 기본 포맷팅 확인', () {
      const exception = GenericCheckedException<String?>(value: null, prefix: 'Auth');

      final output = exception.toString();
      debugPrint(output); // 실제 생성된 문자열을 터미널에 출력

      // (Null as String) 형태의 타입 정보가 포함되어야 함
      expect(exception.toString(), contains('Auth: Failed to parse null (Null as String?)'));
    });

    test('영문 및 로컬 메시지가 있을 때 구조화된 출력 확인', () {
      const exception = GenericCheckedException<int>(
        value: 404,
        prefix: 'Network',
        message: (english: 'Not Found', locale: '찾을 수 없음'),
      );

      final output = exception.toString();
      debugPrint(output); // 실제 생성된 문자열을 터미널에 출력

      expect(output, contains('NetworkException: value = 404 (int)'));
      expect(output, contains('[English] Not Found'));
      expect(output, contains('[Locale] 찾을 수 없음'));
    });

    test('locale이 null일 때 줄바꿈 없이 영문만 출력되는지 확인', () {
      const exception = GenericCheckedException<int>(
        value: 500,
        prefix: 'Server',
        message: (english: 'Internal Error', locale: null),
      );

      final output = exception.toString();
      debugPrint(output);
      expect(output, contains('[English] Internal Error'));
      expect(output, isNot(contains('[Locale]')));
    });
  });

  group('NullableCheckedX (Type Promotion) Tests', () {
    test('throwCheckedIfNull - null일 때 예외 발생', () {
      String? name;
      expect(() => name.throwCheckedIfNull(prefix: 'Test'), throwsA(isA<CheckedException>()));
    });

    test('throwCheckedIfNull - 값이 있을 때 타입 승격 확인', () {
      String? name = 'Dart';
      // 반환된 값이 Non-nullable String인지 확인
      String promotedName = name.throwCheckedIfNull(prefix: 'Test');
      expect(promotedName, equals('Dart'));
    });

    test('throwCheckedIfOrNull - null이거나 조건을 만족할 때 예외 발생', () {
      String? email = 'invalid-email';
      expect(
        () => email.throwCheckedIfOrNull((v) => !v.contains('@'), prefix: 'Email'),
        throwsA(isA<CheckedException>()),
      );

      String? nullEmail;
      expect(
        () => nullEmail.throwCheckedIfOrNull((v) => v.isEmpty, prefix: 'Email'),
        throwsA(isA<CheckedException>()),
      );
    });
  });

  group('NullableUncheckedX (Error) Tests', () {
    test('throwUncheckedIfNull - 발생 시 StackTrace 포함 여부', () {
      try {
        int? value;
        value.throwUncheckedIfNull(prefix: 'Critical');
      } catch (e) {
        expect(e, isA<UncheckedError>());
        expect((e as UncheckedError).stackTrace, isNotNull);
      }
    });
  });

  group('ThrowableX Tests', () {
    test('throwCheckedIf - 조건 만족 시 예외 발생 및 값 반환', () {
      final score = 50;
      expect(
        () => score.throwCheckedIf((v) => v < 60, prefix: 'Grade'),
        throwsA(isA<CheckedException>()),
      );

      final passScore = 80;
      expect(passScore.throwCheckedIf((v) => v < 60, prefix: 'Grade'), equals(80));
    });
  });

  group('BaseExceptionX & BaseExceptionOrNullX Tests', () {
    test('toCheckedException - 객체를 예외로 변환', () {
      final reason = 'Timeout';
      final exception = reason.toCheckedException(
        prefix: 'Conn',
        message: (english: 'Connection timeout', locale: null),
      );
      final output = exception.toString();
      debugPrint(output);

      expect(exception.value, equals('Timeout'));
      expect(exception.prefix, equals('Conn'));
    });

    test('BaseExceptionOrNullX - null 값을 예외로 변환 및 타입 추적 확인', () {
      String? nullValue;
      final exception = nullValue.toCheckedException(
        prefix: 'User',
        message: (english: 'User not found', locale: null),
      );
      final output = exception.toString();
      debugPrint(output);

      expect(exception.value, isNull);
      // nullValue(T?)에 대해 (Null as String?) 출력을 기대함
      expect(exception.toString(), contains('value = null (Null as String?)'));
    });

    test('BaseExceptionOrNullX - UncheckedError 변환 확인', () {
      int? criticalNull;
      final error = criticalNull.toUncheckedError(
        prefix: 'System',
        message: (english: 'Fatal null', locale: null),
      );
      final output = error.toString();
      debugPrint(output);

      expect(error.value, isNull);
      expect(error, isA<UncheckedError<int?>>());
    });
  });
}