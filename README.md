Here is the refined English README. I have polished the terminology, improved the formatting for better readability, and
ensured all code snippets strictly follow the `locale: null` requirement.

# Error Guard 🛡️

`error_guard` is a professional error-handling library for Dart and Flutter designed to manage exceptions and errors
declaratively and safely.

Beyond simple `if-throw` statements, it maximizes debugging efficiency through **Type Promotion** and **Runtime Type
Tracking**.

---

## 🌟 Key Features

* **Type-Based Separation**: Clearly distinguishes between `CheckedException` (predictable business logic) and
  `UncheckedError` (unexpected system/programmer errors).
* **Intelligent Type Tracking**: Analyzes the gap between the expected type (`$T`) and the actual `runtimeType` to
  provide precision logs like `Failed to parse null (Null as User)`.
* **Safe Type Promotion**: Validates nullable data and immediately promotes it to a Non-nullable type, eliminating the
  need for the `!` operator.
* **Universal Conversion**: Effortlessly convert standard objects or even `null` values into structured exception
  instances.
* **Flexible Localization**: Supports mandatory English and optional local messages with clean, dynamic log formatting.

---

## 🚀 Getting Started

### 1. Null Check & Type Promotion (NullableCheckedX)

Safely validate nullable data and use it as a Non-nullable type immediately.

```dart
void processUser(User? user) {
  // Returns as User type on success (User? -> User)
  // Since 'locale' is String?, it must be explicitly marked as 'null' if not used.
  final currentUser = user.throwCheckedIfNull(
    prefix: 'User',
    message: (english: 'User profile not found.', locale: null),
  );

  print(currentUser.name); // Safe to access; type is already promoted
}
```

### 2. Condition Validation (ThrowableX)

Declaratively throw exceptions when business rules are violated.

```dart
void validateAge(int age) {
  age.throwCheckedIf(
        (v) => v < 19,
    prefix: 'Auth',
    message: (english: 'Adult certification required.', locale: 'Local message here'),
  );
}
```

### 3. Complex Validation (IfOrNull)

Ensure a value exists AND satisfies a specific business rule simultaneously.

```dart
void validateEmail(String? inputEmail) {
  final validEmail = inputEmail.throwCheckedIfOrNull(
        (v) => !v.contains('@'),
    prefix: 'Validation',
    message: (english: 'Invalid email format.', locale: null),
  );
}
```

### 4. Manual Conversion (BaseExceptionOrNullX)

Convert existing objects or `null` into exception instances. Perfect for functional patterns like `fpdart`.

```dart
void checkData(String? data) {
  if (data == null) {
    // Convert null itself into a precision exception object
    throw data.toCheckedException(
      prefix: 'Data',
      message: (english: 'Data is missing.', locale: null),
    );
  }
}
```

---

## 🔍 Precision Debugging Logs

`error_guard` tracks the actual runtime type to help you identify the exact cause of failure.

* **English Only (Clean Output)**:
    ```text
    UserException: value = null (Null as User)
    [English] User profile not found.
    ```
* **With Local Message**:
    ```text
    AuthException: value = null (Null as String?)
    [English] Token is missing.
    [Locale] 토큰이 존재하지 않습니다.
    ```

---

## 🛠️ Design Philosophy

1. **CheckedException**: **Predictable failures** (e.g., network issues, validation errors) that the caller **must**
   handle (Catch/Map).
2. **UncheckedError**: **Programmer errors** (e.g., invalid arguments) that require code fixes. Automatically includes a
   `StackTrace`.

---

## 📦 Installation & Exports

Add it to your `pubspec.yaml` and import `error_guard.dart` to start guarding your code.

```dart
import 'package:error_guard/error_guard.dart';
```