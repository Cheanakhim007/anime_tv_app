class AppConfig {
  final int softwareVersion;
  AppConfig({this.softwareVersion});

  @override
  String toString() {
    return 'AppConfig{softwareVersion: $softwareVersion}';
  }
}
class AppConfigUtils {
  static AppConfig appConfig;
  static setAppConfig(AppConfig appConfig){
    AppConfigUtils.appConfig = appConfig;
  }
}