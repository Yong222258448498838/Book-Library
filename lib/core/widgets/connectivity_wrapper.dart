import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:app_settings/app_settings.dart';

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;

  const ConnectivityWrapper({super.key, required this.child});

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  bool _hasConnection = true;
  bool _isChecking = false;
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    try {
      final results = await Connectivity().checkConnectivity();
      _updateConnectionStatus(results);
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
    }

    _subscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    if (!mounted) return;
    setState(() {
      // Connection is active if there is any type other than none
      _hasConnection = results.isNotEmpty &&
          results.any((result) => result != ConnectivityResult.none);
    });
  }

  Future<void> _checkConnectionManually() async {
    if (_isChecking) return;
    setState(() {
      _isChecking = true;
    });

    // Visual feedback delay
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      final results = await Connectivity().checkConnectivity();
      _updateConnectionStatus(results);

      if (!mounted) return;

      if (_hasConnection) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connected to internet!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Still offline. Please check your network settings.'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error manually checking connectivity: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isChecking = false;
        });
      }
    }
  }

  void _openSettings() {
    try {
      AppSettings.openAppSettings(type: AppSettingsType.wifi);
    } catch (e) {
      debugPrint('Error opening settings: $e');
      try {
        AppSettings.openAppSettings();
      } catch (_) {}
    }
  }

  void _enableInternet() {
    if (kIsWeb) {
      _checkConnectionManually();
      return;
    }

    if (Platform.isAndroid) {
      try {
        AppSettings.openAppSettingsPanel(AppSettingsPanelType.internetConnectivity);
      } catch (e) {
        debugPrint('Error opening internet settings panel: $e');
        _openSettings();
      }
    } else {
      // On iOS, settings panel doesn't exist, open wifi settings
      _openSettings();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasConnection) {
      return widget.child;
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F172A), // Slate 900
              Color(0xFF1E1B4B), // Indigo 950
              Color(0xFF311042), // Deep Violet
            ],
            stops: [0.1, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Glowing Wifi-off icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.redAccent.withValues(alpha: 0.25),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.wifi_off_rounded,
                        size: 64,
                        color: Colors.redAccent.shade100,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Title
                  const Text(
                    'No Internet Connection',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Description
                  Text(
                    'It looks like you are offline. Please check your connection or adjust your settings to access the app.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Action buttons
                  Row(
                    children: [
                      // Setting button
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _openSettings,
                          icon: const Icon(Icons.settings_outlined, color: Colors.white70),
                          label: const Text(
                            'Setting',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Enable button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isChecking ? null : _enableInternet,
                          icon: _isChecking
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.wifi_rounded, color: Colors.white),
                          label: const Text(
                            'Enable',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: const Color(0xFF5314E5), // Match app theme color
                            elevation: 8,
                            shadowColor: const Color(0xFF5314E5).withValues(alpha: 0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Manual Check Button
                  if (!_isChecking)
                    TextButton(
                      onPressed: _checkConnectionManually,
                      child: Text(
                        'Check Again',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
