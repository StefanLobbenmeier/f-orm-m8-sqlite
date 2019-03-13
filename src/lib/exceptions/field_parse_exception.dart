class FieldParseException implements Exception {
  dynamic inner;

  String fieldName;

  String message;

  StackTrace trace;

  FieldParseException(this.fieldName, this.inner, this.trace, {this.message});

  String toString() {
    StringBuffer stringBuffer = StringBuffer();
    stringBuffer.writeln('Exception while parsing field: $fieldName!');
    if (message != null) {
      stringBuffer.writeln("Message: $message");
    }
    stringBuffer.writeln(inner);
    stringBuffer.writeln(trace);
    return stringBuffer.toString();
  }
}
