import 'package:flutter/material.dart';
import 'package:final_mobile/core/services/settings_redirection_service.dart';

class SettingsRedirectionExample extends StatelessWidget {
  const SettingsRedirectionExample({super.key});

  Future<void> _openSetting(SettingsType settingsType) async {
    await SettingsRedirectionService.openSettings(settingsType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('Wi-Fi Settings'),
            subtitle: const Text('Open Wi-Fi configuration'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openSetting(SettingsType.wifi),
          ),
          ListTile(
            title: const Text('Mobile Data'),
            subtitle: const Text('Open mobile data settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openSetting(SettingsType.mobileData),
          ),
          ListTile(
            title: const Text('App Settings'),
            subtitle: const Text('Open this app\'s settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openSetting(SettingsType.appSettings),
          ),
        ],
      ),
    );
  }
}
