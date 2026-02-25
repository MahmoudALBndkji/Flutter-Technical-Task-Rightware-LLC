import 'dart:convert';

dynamic extractErrorMessageFromBody(dynamic body) {
  if (body == null) return null;
  try {
    if (body is String) {
      final trimmed = body.trim();
      if ((trimmed.startsWith('{') && trimmed.endsWith('}')) ||
          (trimmed.startsWith('[') && trimmed.endsWith(']'))) {
        return _extractFromDecoded(_tryDecodeJson(trimmed) ?? body);
      }
      return trimmed.isEmpty ? null : trimmed;
    }
    if (body is Map) {
      return _extractFromDecoded(body);
    }
    final asString = body.toString();
    return asString.isEmpty ? null : asString;
  } catch (_) {
    return null;
  }
}

dynamic _tryDecodeJson(String source) {
  try {
    return jsonDecode(source);
  } catch (_) {
    return null;
  }
}

dynamic _extractFromDecoded(dynamic decoded) {
  if (decoded is Map) {
    for (final key in const [
      'Message',
      'detail',
      'message',
      'error',
      'MESSAGE',
      'ERROR'
    ]) {
      if (decoded[key] != null) {
        return decoded[key];
      }
    }
    final errors = decoded['errors'];
    if (errors is List && errors.isNotEmpty) {
      return errors.first.toString();
    }
    if (errors is Map && errors.isNotEmpty) {
      final first = errors.values.first;
      if (first is List && first.isNotEmpty) {
        return first.first.toString();
      }
      return first?.toString();
    }
  }
  return null;
}
