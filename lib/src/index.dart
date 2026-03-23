// ---------------------------------------------------------------------------
// Error Guard - Public API Entry Point
// ---------------------------------------------------------------------------
//
// This file exports the core interfaces and extension methods for the Error Guard package.
// It provides a declarative way to handle exceptions with type promotion and precise logging.
//
// 이 파일은 Error Guard 패키지의 핵심 인터페이스와 확장 메서드를 노출합니다.
// 선언적인 에러 핸들링, 타입 승격(Type Promotion), 그리고 정밀한 디버깅 로그를 제공합니다.
// ---------------------------------------------------------------------------

// 1. Core Exception Architecture (에러 기반 클래스)
// ---------------------------------------------------------------------------
// - CheckedException: Predictable failures in business logic (e.g., validation failure).
//   비즈니스 로직에서 발생할 수 있는 '예상 가능한' 실패를 정의합니다 (예: 유효성 검사 실패).
//
// - UncheckedError: Unexpected system defects or programmer mistakes (e.g., invalid arguments).
//   시스템 결함이나 프로그래머의 실수 등 '예상치 못한' 오류를 정의하며 StackTrace를 포함합니다.
// 2. Manual Conversion Extensions (수동 변환 확장 메서드)
// ---------------------------------------------------------------------------
// - BaseExceptionX: Immediately converts a standard object into an exception/error instance.
//   일반 객체를 즉시 예외 또는 에러 인스턴스로 변환합니다.
//
// - BaseExceptionOrNullX: Converts including null values; optimized for functional programming (e.g., fpdart).
//   null 값을 포함하여 예외/에러 인스턴스로 변환하며, 함수형 프로그래밍 패턴 연동에 최적화되어 있습니다.
// 3. Declarative Validation & Type Promotion (선언적 검증 및 타입 승격)
// ---------------------------------------------------------------------------
// - ThrowableX: Throws an exception immediately when a specific condition is met.
//   특정 조건을 만족할 경우 즉시 예외를 발생시키는 흐름을 제공합니다.
//
// - NullableCheckedX: Promotes to Non-nullable type after a null check (Checked Exception).
//   Null 체크 후 데이터를 Non-nullable 타입으로 즉시 승격시키며, 비즈니스 예외를 던집니다.
//
// - NullableUncheckedX: Promotes to Non-nullable type after a null check (Unchecked Error).
//   시스템적으로 절대 null이면 안 되는 곳에서 사용하며, 실패 시 언체크 에러를 던집니다.
export 'error_base_exception.dart' show ThrowableX, NullableCheckedX, NullableUncheckedX;
export 'error_base_exception.dart' show BaseExceptionX, BaseExceptionOrNullX;
export 'error_base_exception.dart' show CheckedException, UncheckedError;