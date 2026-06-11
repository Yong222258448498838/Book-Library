import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

enum SettingsType {
  wifi,
  mobileData,
  appSettings,
}

class SettingsRedirectionService {
  static Future<bool> openSettings(SettingsType settingsType) async {
    try {
      if (Platform.isAndroid) {
        return _openAndroidSettings(settingsType);
      } else if (Platform.isIOS) {
        return _openIOSSettings(settingsType);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> _openAndroidSettings(SettingsType settingsType) async {
    late final String url;

    switch (settingsType) {
      case SettingsType.wifi:
        url = 'android.settings.WIFI_SETTINGS';
        break;
      case SettingsType.mobileData:
        url = 'android.settings.WIRELESS_SETTINGS';
        break;
      case SettingsType.appSettings:
        url = 'android.app.action.APP_SETTINGS';
        break;
    }

    final Uri androidUri = Uri(scheme: 'intent', host: '', path: url);
    return launchUrl(androidUri, mode: LaunchMode.externalApplication);
  }

  static Future<bool> _openIOSSettings(SettingsType settingsType) async {
    switch (settingsType) {
      case SettingsType.appSettings:
        return launchUrl(
          Uri.parse('app-settings:'),
          mode: LaunchMode.externalApplication,
        );
      case SettingsType.wifi:
      case SettingsType.mobileData:
        return launchUrl(
          Uri.parse('app-settings:root=SETTINGS'),
          mode: LaunchMode.externalApplication,
        );
    }
  }
}
