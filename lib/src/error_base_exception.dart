part 'error_checked_exception.dart';
part 'error_unchecked.dart';
part 'extension.dart';

/// The top-level abstract base class for all exceptions and errors within the application.
///
/// `BaseException` provides common management for the data that caused the error (`value`),
/// an identification prefix (`prefix`), and detailed messages supporting multiple languages (`message`).
///
/// 애플리케이션 내 모든 예외 및 오류의 최상위 추상 클래스입니다.
///
/// `BaseException`은 발생한 에러의 원인 데이터(`value`), 식별을 위한 접두어(`prefix`),
/// 그리고 다국어를 지원하는 상세 메시지(`message`)를 공통적으로 관리합니다.
///
/// It cannot be instantiated directly and must be specialized through `CheckedException` or `UncheckedError`.
///
/// 직접 인스턴스화할 수 없으며, `CheckedException` 또는 `UncheckedError`를 통해 구체화됩니다.
abstract final class BaseException<T> {
  /// The raw data that directly caused the exception to occur.
  ///
  /// By including the actual type information (`value.runtimeType`) in the logs at runtime,
  /// it enables rapid identification of type mismatch issues during debugging.
  ///
  /// 예외 발생의 직접적인 원인이 된 데이터입니다.
  ///
  /// 런타임 시 실제 타입 정보(`value.runtimeType`)를 로그에 포함하여
  /// 디버깅 시 타입 불일치 문제를 빠르게 식별할 수 있도록 합니다.
  final T value;

  /// A name prefix representing the identity of the exception.
  ///
  /// Example: `Auth`, `Network`, `Parsing`, etc.
  /// It is combined into forms such as `AuthException` or `AuthError` upon output.
  ///
  /// 예외의 정체성을 나타내는 이름 접두사입니다.
  ///
  /// 예: `Auth`, `Network`, `Parsing` 등.
  /// 출력 시 `AuthException` 또는 `AuthError`와 같은 형태로 조합됩니다.
  final String prefix;

  /// Detailed description messages to be exposed to users or recorded in logs.
  ///
  /// - `english`: English description for system logging or global services.
  /// - `locale`: Description in languages other than English. (options)
  ///
  /// 사용자에게 노출하거나 로그에 기록할 상세 설명 메시지입니다.
  ///
  /// - `english`: 영문 설명 (시스템 로깅 또는 글로벌 서비스용)
  /// - `locale`: 영문 이외에 언어 설명 (옵션)
  final ({String english, String? locale}) message;

  /// Internal constructor for `BaseException`.
  ///
  /// `BaseException`의 내부 생성자입니다.
  const BaseException({required this.value, required this.prefix, required this.message});

  /// Generates a specific error message.
  ///
  /// Returns a concise default message or a structured detailed message based on the presence of `message`.
  /// `errorPrefix` is determined by the nature of the concrete class, such as `Exception` or `Error`.
  ///
  /// 구체적인 에러 메시지를 생성합니다.
  ///
  /// `message`의 유무에 따라 간결한 기본 메시지 또는 구조화된 상세 메시지를 반환합니다.
  /// `errorPrefix`는 `Exception` 또는 `Error`와 같이 구체 클래스의 성격에 따라 결정됩니다.
  String createMessage({required String errorPrefix}) {
    // 1. 타입 정보 구성
    final String typeInfo = switch (value.runtimeType.toString() == T.toString()) {
      true => '($T)',
      false => '(${value.runtimeType} as $T)',
    };

    // 2. 메시지 존재 여부 및 바디 구성
    final bool hasEnglish = message.english.isNotEmpty;
    final bool hasLocale = message.locale?.isNotEmpty ?? false;
    final bool messageIsEmpty = !hasEnglish && !hasLocale;

    // 3. 메시지 바디 조립
    final List<String> bodyParts = [
      '[English] ${message.english}',
      if (hasLocale) '[Locale] ${message.locale}',
    ];
    final String messageBody = bodyParts.join('\n');

    // 4. 최종 결과 반환
    return switch (messageIsEmpty) {
      true => '$prefix: Failed to parse $value $typeInfo',
      false => '$prefix$errorPrefix: value = $value $typeInfo\n$messageBody',
    };
  }
}