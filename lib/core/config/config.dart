final class AppConfig {
  const AppConfig._();

  static const bool thunderEnabled = bool.fromEnvironment(
    'THUNDER_ENABLED',
    defaultValue: false,
  );
}
