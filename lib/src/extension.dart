part of 'error_base_exception.dart';

/// 객체를 예외 객체로 간편하게 변환하는 확장 기능을 제공합니다.
///
/// Provides extension methods to easily convert objects into exception or error instances.
extension BaseExceptionX<T extends Object> on T {
  /// 현재 데이터를 원인(`value`)으로 하는 `CheckedException`을 생성합니다.
  ///
  /// 비즈니스 로직 중 '예상 가능한' 실패 지점에서 호출합니다.
  /// `prefix`는 에러의 범주(예: 'Auth', 'Validation'), `message`는 상세 설명을 전달합니다.
  ///
  /// Creates a `CheckedException`]using the current data as the cause (`value`).
  /// Call this at 'predictable' failure points within business logic.
  CheckedException<T> toCheckedException({
    required String prefix,
    Messages message = (english: '', locale: ''),
  }) {
    return GenericCheckedException<T>(value: this, prefix: prefix, message: message);
  }

  /// 현재 데이터를 원인(`value`)으로 하는 `UncheckedError`를 생성합니다.
  ///
  /// 프로그래머의 실수나 시스템 불변성이 깨진 '예상치 못한' 지점에서 호출합니다.
  /// `stackTrace`를 통해 발생 지점의 상세한 디버깅 정보를 포함할 수 있습니다.
  ///
  /// Creates an `UncheckedError` using the current data as the cause (`value`).
  /// Call this at 'unexpected' points where programmer mistakes occur or system invariants are broken.
  UncheckedError<T> toUncheckedError({
    required String prefix,
    Messages message = (english: '', locale: ''),
    StackTrace? stackTrace,
  }) {
    return GenericUncheckedError<T>(
      value: this,
      prefix: prefix,
      message: message,
      stackTrace: stackTrace ?? StackTrace.current,
    );
  }
}

/// Nullable 객체를 예외 객체로 변환하는 확장 기능을 제공합니다.
///
/// Provides extension methods to convert nullable objects into exception or error instances.
extension BaseExceptionOrNullX<T extends Object> on T? {
  /// 현재 데이터(null 포함)를 원인(`value`)으로 하는 `CheckedException`을 생성합니다.
  ///
  /// 데이터가 null인 상태 자체가 비즈니스 예외의 원인일 때 사용합니다.
  ///
  /// Creates a `CheckedException` using the current nullable data as the cause (`value`).
  /// Used when the null state itself is the cause of a business exception.
  CheckedException<T?> toCheckedException({required String prefix, required Messages message}) {
    return GenericCheckedException<T?>(value: this, prefix: prefix, message: message);
  }

  /// 현재 데이터(null 포함)를 원인(`value`)으로 하는 `UncheckedError`를 생성합니다.
  ///
  /// 시스템적으로 절대 null이면 안 되는 데이터가 null일 때 이를 에러 객체로 래핑합니다.
  ///
  /// Creates an `UncheckedError` using the current nullable data as the cause (`value`).
  /// Wraps the data into an error when it is null but systemically should not be.
  UncheckedError<T?> toUncheckedError({
    required String prefix,
    required Messages message,
    StackTrace? stackTrace,
  }) {
    return GenericUncheckedError<T?>(
      value: this,
      prefix: prefix,
      message: message,
      stackTrace: stackTrace ?? StackTrace.current,
    );
  }
}

/// Any 타입의 데이터에서 즉시 예외를 발생시킬 수 있는 확장 기능을 제공합니다.
///
/// Provides extension methods to immediately throw exceptions from any data type.
extension ThrowableX<T> on T {
  /// 특정 조건(`condition`)이 참일 경우 `CheckedException`을 발생시킵니다.
  ///
  /// 주로 비즈니스 로직 검증 시 사용하며, 예측 가능한 예외를 던집니다.
  /// 호출자가 이 예외를 처리(catch)할 것으로 기대할 때 사용합니다.
  ///
  /// Throws a `CheckedException` if the specified `condition` is true.
  /// Primarily used for business logic validation, throwing predictable exceptions.
  T throwCheckedIf(
    bool Function(T value) condition, {
    required String prefix,
    Messages message = (english: '', locale: ''),
  }) {
    if (condition(this)) {
      throw GenericCheckedException(value: this, prefix: prefix, message: message);
    }
    return this;
  }

  /// 특정 조건(`condition`)이 참일 경우 `UncheckedError`를 발생시킵니다.
  ///
  /// 프로그래머의 실수나 논리적 오류가 의심되는 치명적 상황에서 사용합니다.
  /// 시스템을 즉시 중단시키고 코드를 수정해야 하는 상황에 적합합니다.
  ///
  /// Throws an `UncheckedError` if the specified `condition` is true.
  /// Used in critical situations where programmer mistakes or logical errors are suspected.
  T throwUncheckedIf(
    bool Function(T value) condition, {
    required String prefix,
    Messages message = (english: '', locale: ''),
    StackTrace? stackTrace,
  }) {
    if (condition(this)) {
      throw GenericUncheckedError(
        value: this,
        prefix: prefix,
        message: message,
        stackTrace: stackTrace ?? StackTrace.current,
      );
    }
    return this;
  }
}

/// Nullable 타입 데이터에서 안전하게 예외를 발생시키고 Non-nullable로 변환하는 확장 기능입니다.
///
/// Provides extension methods to safely throw exceptions from nullable data and promote to non-nullable.
extension NullableCheckedX<T extends Object> on T? {
  /// 데이터가 null일 경우 `CheckedException`을 발생시키고, 아닐 경우 Non-nullable 값을 반환합니다.
  ///
  /// 예외 발생 시 어떤 타입(`T`)이 null이었는지 로그에 명시합니다.
  /// 주로 API 필수 응답값이 누락되는 등 비즈니스 로직상 필수 데이터가 없을 때 사용합니다.
  ///
  /// Throws a `CheckedException` if the value is null, otherwise returns the non-nullable value.
  /// Mentions the specific type `T` in the error value for better debugging.
  T throwCheckedIfNull({required String prefix, Messages message = (english: '', locale: '')}) {
    if (this == null) {
      throw GenericCheckedException(value: this, prefix: prefix, message: message);
    }
    return this as T;
  }

  /// 데이터가 null이거나 특정 조건(`condition`)을 만족할 경우 `CheckedException`을 발생시킵니다.
  ///
  /// `throwCheckedIfNull`을 먼저 수행하여 값의 존재를 보장한 뒤 비즈니스 조건을 검사합니다.
  /// 값이 반드시 존재해야 하며, 동시에 특정 규칙을 통과해야 하는 복합 검증 시나리오에 적합합니다.
  ///
  /// Throws a `CheckedException` if the value is null or satisfies the specified `condition`.
  /// Ensures the existence of the value first, then validates the business condition.
  T throwCheckedIfOrNull(
    bool Function(T value) condition, {
    required String prefix,
    ({String english, String? locale}) message = (english: '', locale: ''),
  }) {
    final T value = throwCheckedIfNull(prefix: prefix, message: message);

    if (condition(value)) {
      throw GenericCheckedException(value: value, prefix: prefix, message: message);
    }

    return value;
  }
}

/// Nullable 타입 데이터에서 시스템 오류를 발생시키고 Non-nullable로 변환하는 확장 기능입니다.
///
/// Provides extension methods to throw unchecked errors from nullable data and promote to non-nullable.
extension NullableUncheckedX<T extends Object> on T? {
  /// 데이터가 null일 경우 `UncheckedError`를 발생시키고, 아닐 경우 Non-nullable 값을 반환합니다.
  ///
  /// 절대 null일 수 없는 내부 상태나 DI 객체가 누락된 치명적 상황에서 사용합니다.
  /// 발생 시점의 타입 정보(`T`)를 포함하여 프로그래머의 실수를 빠르게 식별할 수 있도록 돕습니다.
  ///
  /// Throws an `UncheckedError` if the value is null, otherwise returns the non-nullable value.
  /// Includes type `T` information to help identify programmer errors quickly.
  T throwUncheckedIfNull({
    required String prefix,
    Messages message = (english: '', locale: ''),
    StackTrace? stackTrace,
  }) {
    if (this == null) {
      throw GenericUncheckedError(
        value: this,
        prefix: prefix,
        message: message,
        stackTrace: stackTrace ?? StackTrace.current,
      );
    }
    return this as T;
  }

  /// 데이터가 null이거나 특정 조건(`condition`)을 만족할 경우 `UncheckedError`를 발생시킵니다.
  ///
  /// 데이터가 존재하지 않거나, 시스템 불변성(Invariant)이 깨진 치명적 상태일 때 사용합니다.
  /// [throwUncheckedIfNull]을 통해 원천적인 Null 체크를 마친 후 상세 로직 위반 여부를 확인합니다.
  ///
  /// Throws an `UncheckedError` if the value is null or satisfies the specified `condition`.
  /// Checks for nullity first, then confirms if system invariants are maintained.
  T throwUncheckedIfOrNull(
    bool Function(T value) condition, {
    required String prefix,
    Messages message = (english: '', locale: ''),
    StackTrace? stackTrace,
  }) {
    final T value = throwUncheckedIfNull(prefix: prefix, message: message, stackTrace: stackTrace);

    if (condition(value)) {
      throw GenericUncheckedError(
        value: value,
        prefix: prefix,
        message: message,
        stackTrace: stackTrace ?? StackTrace.current,
      );
    }
    return value;
  }
}