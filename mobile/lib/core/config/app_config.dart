/// Backend base URL. Override at build/run time with
/// `--dart-define=API_BASE_URL=https://api.example.com`
/// (docs/DEPLOYMENT_PLAN.md). Defaults to the local dev backend.
class AppConfig {
  AppConfig._();

  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );
}
