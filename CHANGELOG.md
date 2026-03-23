# Changelog

## [1.0.3] - 2026-03-24

### Added

* **Generic Exception & Error System**: Introduced `GenericCheckedException` and `GenericUncheckedError` to provide a
  standardized way of handling Dart core exceptions and errors.
* **Structured Data Tracking**: Added the ability to capture the raw `value` and its `runtimeType` within exceptions to
  enable rapid identification of type mismatches during debugging.
* **Dart Core Mapping**: Added `DartExceptionMessage` and `DartErrorMessage` enums to provide consistent error prefixes
  and default messages for common Dart-related failures.
* **Specialized Internal Concrete Classes**:
  * `_FormatException`: Captures specific `offset` data for parsing errors.
  * `_OutOfError`: Captures `start` and `end` range information for index and range-related errors.
  * `_IntegerDivisionByZeroException`: Specifically handles non-finite division results.
* **Factory Methods**: Added `.dartCore()` factory constructors to both `GenericCheckedException` and
  `GenericUncheckedError` for a unified entry point when wrapping standard Dart failures.

### Changed

* **Enhanced Diagnostics**: Improved `createMessage` logic to automatically include type information and structured body
  parts (English/Locale) in the error output.
* **Strict Encapsulation**: Concrete exception subclasses are now private (`_`), forcing the use of the centralized
  factory system and ensuring API stability.
* **Naming Consistency**: Updated internal enum members (e.g., `noSuchMethodNotFound`, `outOfRange`) to prevent naming
  collisions with existing Dart top-level functions or properties.

### Fixed

* **Consistency in Error Output**: Fixed inconsistent string representations by overriding `toString()` to ensure all
  `UncheckedError` instances follow the `prefix + Error` format.
* **StackTrace Handling**: Refined the `UncheckedError` structure to ensure `StackTrace` is properly preserved and
  exposed for logical system errors.

## [1.0.1] - 2026-03-23

### Added

- **Comprehensive Examples**:
  - Added `example/main.dart` covering all core features including Type Promotion and Error/Exception separation.
  - Added `example/fpdart_example.dart` demonstrating seamless integration with functional programming patterns using
    `Either` and `TaskEither`.
- **Project Metadata**: Added `homepage`, `repository`, `issue_tracker`, and `topics` to `pubspec.yaml` for better
  discoverability on pub.dev.

### Changed

- **Documentation Refinement**: Updated all doc comments to use backticks (`` `value` ``) instead of brackets (
  `[value]`) where symbol resolution was not possible, resolving all `dartdoc` warnings.
- **Improved Type Safety**: Refined `message` record types in extension methods to ensure consistent behavior across the
  API.

### Fixed

- **Unresolved Doc References**: Fixed 7 `dartdoc` warnings related to unresolved references in `BaseExceptionX` and
  `BaseExceptionOrNullX`.
- **TaskEither Type Inference**: Corrected a type mismatch in the fpdart example to ensure proper `CheckedException<T>`
  propagation.

All notable changes to this project will be documented in this file.

## [1.0.0] 2026-03-23

### Added

- **Core Architecture**: Introduced `BaseException`, `CheckedException`, and `UncheckedError` for structured error
  handling.
- **Precision Type Tracking**: Added an intelligent tracking engine that compares expected types `($T)` with actual
  `runtimeType` to provide detailed debugging context.
- **Extension Methods**:
  - `BaseExceptionX`: Seamless conversion of any object into an exception or error.
  - `BaseExceptionOrNullX`: Added support for converting `null` values into structured exceptions with accurate type
    tracing.
  - `ThrowableX`: Declarative condition checks (`throwCheckedIf`) for cleaner business logic.
  - `NullableCheckedX` & `NullableUncheckedX`: Integrated null-safety validation with automatic **Type Promotion**.
- **Localization System**: Implemented structured multi-language support with mandatory `english` and optional `locale`
  fields.
- **Dynamic Formatting**: Optimized log generation using `List.join()` to ensure clean output without unnecessary empty
  lines.
- **Comprehensive Documentation**: Provided English and Korean READMEs with IDE-safe, runnable code examples.
- **Test Suite**: Developed full unit tests covering type promotion, message building, and error classification.

### Changed

- Refined `createMessage` logic to gracefully handle optional `locale` strings.
- Updated extension methods to preserve original `this` values, ensuring accurate type analysis in lower layers.
- Encapsulated internal implementations (`Generic...`) by restricting public exports via `index.dart`.

### Fixed

- Resolved an issue where missing `locale` strings caused unwanted blank lines in error logs.
- Fixed syntax errors in documentation examples by wrapping snippets in function blocks and ensuring explicit `null` for
  record fields.