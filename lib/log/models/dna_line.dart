class DnaLine {
  /// Timestamp for the log line
  String timestamp;

  /// Log statement
  String line;

  /// Log level (E.g. Debug, Info, Error)
  String level;

  /// the current environment of the application.
  String env;

  /// App name
  String? app;

  ///Meta is a field reserved for custom information associated with a log line.
  ///To add metadata to an API call, specify the meta field under the lines object.
  ///Metadata can be viewed inside that line's context.
  ///WARNING: If inconsistent value types are used, that line's metadata, will not be parsed.
  ///For example, if a line is passed with a meta object, such as meta.myfield of type String, any subsequent lines with meta.myfield must have a String as the value type for meta.myfield.
  ///Source: LogDNA official documentation.
  Map<String, dynamic>? meta;

  DnaLine({
    required this.timestamp,
    required this.line,
    required this.level,
    required this.env,
    this.app,
    this.meta,
  });

  factory DnaLine.fromJson(Map<String, dynamic> json) => DnaLine(
        timestamp: json['timestamp'],
        line: json['line'],
        app: json['app'],
        level: json['level'],
        env: json['env'],
        meta: json['meta'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['timestamp'] = timestamp;
    data['line'] = line;
    data['level'] = level;
    data['env'] = env;
    if (app != null) {
      data['app'] = app;
    }
    if (meta != null) {
      data['meta'] = meta;
    }
    return data;
  }

  /// Add a custom field to a log line
  addCustomField(CustomField customField) {
    meta ??= {};
    meta!.putIfAbsent(customField.name, () => customField.value);
  }
}

/// A custom field added to the DnaLine. It's passed into the ingestion API under the meta field.
class CustomField {
  final String name;
  final String value;

  CustomField({required this.name, required this.value});
}

/// DnaLevel is a string indicating the log level. Custom values are allowed.
class DnaLevel {
  static const String info = "INFO";
  static const String error = "ERROR";
  static const String warn = "WARN";
  static const String trace = "TRACE";
  static const String debug = "DEBUG";
  static const String fatal = "FATAL";
}

/// The current environment (e.g. development, production)
class DnaEnv {
  static const String production = "production";
  static const String staging = "staging";
  static const String testing = "testing";
  static const String development = "development";
}
