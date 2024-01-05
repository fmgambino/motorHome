/// An interface for HTTP errors.
abstract class IHttpError<T> {
  /// The error object.
  T? get error;

  /// The stack trace of the error.
  StackTrace? get stackTrace;

  /// The error object.
  Object? get e;
}
