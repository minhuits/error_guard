part of 'error_base_exception.dart';

/// Defines 'unexpected' errors occurring due to programmer mistakes or fatal system failures.
///
/// According to Dart's philosophy, an `Error` is not intended to be caught and recovered from,
/// but rather represents an issue that should be resolved by fixing the code.
/// Therefore, this class is used for `throw`ing outside of the `fpdart` flow or
/// for terminating the process when logical invariants are broken.
///
/// **Use cases:** Invalid argument passing, Null safety violations, state contradictions, etc.
///
/// 프로그래머의 실수나 시스템의 치명적 결함으로 발생하는 '예상치 못한' 오류를 정의합니다.
///
/// Dart의 철학에 따라 `Error`는 catch하여 복구하는 것이 아니라, 코드를 수정하여
/// 해결해야 하는 대상을 의미합니다. 따라서 이 클래스는 `fpdart` 흐름 밖에서 `throw`되거나,
/// 로직상의 불변성이 깨졌을 때 프로세스를 중단시키는 목적으로 사용합니다.
///
/// **사용 예:** 잘못된 아규먼트 전달, Null 안정성 위반, 상태 모순 등.
sealed class UncheckedError<T> extends BaseException<T> implements Error {
  /// The call stack information at the point where the error occurred.
  ///
  /// Used to trace the point of origin during debugging.
  ///
  /// 오류가 발생한 지점의 호출 스택 정보입니다.
  ///
  /// 디버깅 시 발생 지점을 추적하기 위해 사용됩니다.
  @override
  final StackTrace? stackTrace;

  /// Creates an instance of `UncheckedError`.
  ///
  /// Since this represents a logical error in the system, it is recommended to include
  /// a `stackTrace` whenever possible.
  ///
  /// `UncheckedError` 인스턴스를 생성합니다.
  ///
  /// 시스템의 논리적 오류를 나타내므로 가능한 한 `stackTrace`를 포함하는 것이 권장됩니다.
  const UncheckedError({
    required super.value,
    required super.prefix,
    super.message = (english: '', locale: null),
    this.stackTrace,
  });

  /// Returns the standard string representation of the `Error`.
  ///
  /// The result is a structured string including the form 'prefix + "Error"'.
  ///
  /// `Error`의 표준 문자열 표현을 반환합니다.
  ///
  /// 결과물은 `prefix + "Error"` 형태를 포함하는 구조화된 문자열입니다.
  @override
  String toString() => createMessage(errorPrefix: 'Error');
}

/// `UncheckedError`의 구체적인 기본 구현체입니다.
///
/// Concrete implementation of `UncheckedError`.
final class GenericUncheckedError<T> extends UncheckedError<T> {
  const GenericUncheckedError({
    required super.value,
    required super.prefix,
    super.message,
    super.stackTrace,
  });

  factory GenericUncheckedError.dartCore({
    required T value,
    required DartErrorMessage info,
    StackTrace? stackTrace,
    String? locale,
    dynamic start,
    dynamic end,
  }) => info.create(value, stackTrace: stackTrace, locale: locale, start: start, end: end);
}

enum DartErrorMessage {
  assertion(prefix: 'Assertion', message: 'Assertion failed.'),
  type(prefix: 'Type', message: 'Unexpected type encountered.'),
  argument(prefix: 'Argument', message: 'Invalid argument provided.'),
  outOfRange(prefix: 'Range', message: 'Value out of valid range.'),
  outOfIndex(prefix: 'Index', message: 'Index out of bounds.'),
  noSuchMethodNotFound(prefix: 'NoSuchMethod', message: 'Method not found.'),
  unsupported(prefix: 'Unsupported', message: 'The operation is not supported.'),
  unimplemented(prefix: 'Unimplemented', message: 'The feature is not implemented yet.'),
  state(prefix: 'State', message: 'Invalid object state for this operation.'),
  concurrentModification(
    prefix: 'ConcurrentModification',
    message: 'Collection was modified during iteration.',
  ),
  outOfMemory(prefix: 'OutOfMemory', message: 'System ran out of memory.'),
  stackOverflow(prefix: 'StackOverflow', message: 'Recursive call limit exceeded.');

  final String prefix;
  final String message;

  const DartErrorMessage({required this.prefix, required this.message});
}

extension _DartErrorMessageX on DartErrorMessage {
  Messages toMessages([String? locale]) => (english: message, locale: locale);

  GenericUncheckedError<T> create<T>(
    T value, {
    StackTrace? stackTrace,
    String? locale,
    dynamic start, // RangeError용
    dynamic end, // RangeError용
  }) {
    return switch (this) {
      DartErrorMessage.outOfRange || DartErrorMessage.outOfIndex => _OutOfError<T>(
        value: value,
        prefix: prefix,
        message: toMessages(locale),
        stackTrace: stackTrace,
        start: start,
        end: end,
      ),
      _ => GenericUncheckedError<T>(
        value: value,
        prefix: prefix,
        message: toMessages(locale),
        stackTrace: stackTrace,
      ),
    };
  }
}

final class _OutOfError<T> extends GenericUncheckedError<T> {
  final dynamic start;
  final dynamic end;

  const _OutOfError({
    required super.value,
    required super.prefix,
    super.message,
    super.stackTrace,
    this.start,
    this.end,
  });

  @override
  String createMessage({required String errorPrefix}) {
    final String base = super.createMessage(errorPrefix: errorPrefix);
    final List<String> rangeInfo = [
      if (start != null) 'start: $start',
      if (end != null) 'end: $end',
    ];

    return rangeInfo.isNotEmpty ? '$base (Range: ${rangeInfo.join(', ')})' : base;
  }
}