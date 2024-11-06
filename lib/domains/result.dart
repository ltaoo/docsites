class BizError {
  final String message;
  final dynamic code;

  BizError(this.message, [this.code]);
}

class _Result<T> {
  final T? data;
  final dynamic code;
  final BizError? error;
  final dynamic profile;

  _Result({required this.data, this.code, this.error, this.profile});
}

class Result<T> {
  final _Result<T> _resp;

  Result.ok(T value, [dynamic code, dynamic profile]) : _resp = _Result<T>(data: value, code: code, error: null, profile: profile);
  Result.error(dynamic message, [dynamic code, dynamic profile]) : _resp = _Result<T>(data: null, code: code, error: _createError(message, code), profile: profile);

  BizError? get error => _resp.error;
  T? get data => _resp.data;

  static BizError? _createError(dynamic message, [dynamic code]) {
    if (message == null) {
      return BizError("未知错误");
    }
    if (message is String) {
      return BizError(message, code);
    }
    if (message is Error) {
      return BizError(message.toString(), code);
    }
    return null; // Return null if it's an invalid type.
  }

  _Result<T>? get response => _resp;
}
