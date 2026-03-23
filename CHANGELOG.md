# Changelog

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