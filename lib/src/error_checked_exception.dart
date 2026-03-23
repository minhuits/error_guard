part of 'error_base_exception.dart';

/// A class that defines 'predictable' failures occurring due to external factors.
///
/// It is primarily used as the `Left` type in `Either<CheckedException, T>` or `TaskEither`
/// when using the `fpdart` package. This represents a business logic exception that
/// the caller must explicitly handle (via Catch or Map).
///
/// **Use cases:** Data validation failure, API response error, insufficient permissions, etc.
///
/// 외부 요인으로 인해 발생하는 '예상 가능한' 실패를 정의하는 클래스입니다.
///
/// 주로 `fpdart` 패키지를 사용할 때 `Either<CheckedException, T>` 또는 `TaskEither`의
/// `Left` 타입으로 활용됩니다. 이는 호출자가 명시적으로 처리(Catch or Map)해야 하는
/// 비즈니스 로직상의 예외를 의미합니다.
///
/// **사용 예:** 데이터 검증 실패, API 응답 오류, 권한 부족 등.
sealed class CheckedException<T> extends BaseException<T> implements Exception {
  /// Creates an instance of [CheckedException].
  ///
  /// If [message] is omitted, a default failure message is generated.
  ///
  /// [CheckedException] 인스턴스를 생성합니다.
  ///
  /// [message]를 생략할 경우 기본 실패 메시지가 생성됩니다.
  const CheckedException({
    required super.value,
    required super.prefix,
    super.message = (english: '', locale: null),
  });

  /// Returns the standard string representation of the [Exception].
  ///
  /// The result is a structured string including the form 'prefix + "Exception"'.
  ///
  /// [Exception]의 표준 문자열 표현을 반환합니다.
  ///
  /// 결과물은 `prefix + "Exception"` 형태를 포함하는 구조화된 문자열입니다.
  @override
  String toString() => createMessage(errorPrefix: 'Exception');
}

/// `CheckedException`의 구체적인 기본 구현체입니다.
///
/// Concrete implementation of `CheckedException`.
final class GenericCheckedException<T> extends CheckedException<T> {
  const GenericCheckedException({required super.value, required super.prefix, super.message});

  factory GenericCheckedException.dartCore({
    required T value,
    required DartExceptionMessage info,
    String? customLocale,
    final int? offset,
  }) => info.create(value, locale: customLocale, offset: offset);
}

enum DartExceptionMessage {
  format(english: 'The provided value does not match the expected format.', prefixName: 'Format'),
  integerDivisionByZero(
    english: 'Division resulted in non-finite value.',
    prefixName: 'IntegerDivisionByZero',
  );

  final String english;
  final String prefixName;

  const DartExceptionMessage({required this.english, required this.prefixName});
}

extension _DartExceptionMessageX on DartExceptionMessage {
  Messages toMessages([String? locale]) => (english: english, locale: locale);

  // Enum에서 직접 예외 객체를 생성하는 기능을 부여하여 책임을 분산할 수 있습니다.
  GenericCheckedException<T> create<T>(T value, {int? offset, String? locale}) {
    return switch (this) {
      DartExceptionMessage.format => _FormatException<T>(
        value: value,
        prefix: prefixName,
        message: toMessages(locale),
        offset: offset,
      ),
      DartExceptionMessage.integerDivisionByZero => _IntegerDivisionByZeroException<T>(
        value: value,
        prefix: prefixName,
        message: toMessages(locale),
      ),
    };
  }
}

// Dart Core: FormatException
final class _FormatException<T> extends GenericCheckedException<T> {
  final int? offset;

  const _FormatException({required super.value, required super.prefix, super.message, this.offset});

  @override
  String createMessage({required String errorPrefix}) {
    final String base = super.createMessage(errorPrefix: errorPrefix);
    return offset != null ? '$base (at offset $offset)' : base;
  }
}

// Dart Core: IntegerDivisionByZeroException
final class _IntegerDivisionByZeroException<T> extends GenericCheckedException<T> {
  const _IntegerDivisionByZeroException({
    required super.value,
    required super.prefix,
    super.message,
  });
}