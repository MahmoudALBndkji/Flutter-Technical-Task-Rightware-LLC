import 'dart:io';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_technical_task_rightware_llc/core/languages/app_localizations.dart';
import 'package:root_checker_plus/root_checker_plus.dart';

enum SecurityThreat {
  rootDetected,
  jailbreakDetected,
  developerModeEnabled,
  debugModeEnabled,
  emulatorDetected,
}

class SecurityService {
  static final SecurityService _instance = SecurityService._internal();
  factory SecurityService() => _instance;
  SecurityService._internal();

  bool _isSecure = true;
  SecurityThreat? _currentThreat;

  /// Perform comprehensive security check
  Future<SecurityCheckResult> performSecurityCheck(BuildContext context) async {
    try {
      // Check for root/jailbreak
      if (Platform.isAndroid) {
        final isRooted = await RootCheckerPlus.isRootChecker();
        if (isRooted == true) {
          _isSecure = false;
          _currentThreat = SecurityThreat.rootDetected;
          return SecurityCheckResult(
            isSecure: false,
            threat: SecurityThreat.rootDetected,
            message: _getLocalizedMessage(context, 'rooted_device_detected'),
          );
        }
      } else if (Platform.isIOS) {
        final isJailbroken = await RootCheckerPlus.isJailbreak();
        if (isJailbroken == true) {
          _isSecure = false;
          _currentThreat = SecurityThreat.jailbreakDetected;
          return SecurityCheckResult(
            isSecure: false,
            threat: SecurityThreat.jailbreakDetected,
            message: _getLocalizedMessage(
              context,
              'jailbroken_device_detected',
            ),
          );
        }
      }

      // Check for developer mode
      if (Platform.isAndroid) {
        try {
          final isDeveloperMode = await RootCheckerPlus.isDeveloperMode();
          if (isDeveloperMode == true) {
            _isSecure = false;
            _currentThreat = SecurityThreat.developerModeEnabled;
            return SecurityCheckResult(
              isSecure: false,
              threat: SecurityThreat.developerModeEnabled,
              message: _getLocalizedMessage(context, 'developer_mode_enabled'),
            );
          }
        } catch (e) {
          debugPrint('Developer mode check error: $e');
        }
      }

      // Check for debug mode (only in release builds)
      // Note: We skip this check in debug mode to allow development
      // Uncomment if you want to block debug mode even in development
      // if (kDebugMode) {
      //   _isSecure = false;
      //   _currentThreat = SecurityThreat.debugModeEnabled;
      //   return SecurityCheckResult(
      //     isSecure: false,
      //     threat: SecurityThreat.debugModeEnabled,
      //     message: 'Debug mode is enabled',
      //   );
      // }

      // Check for emulator/simulator
      try {
        final deviceInfoPlugin = DeviceInfoPlugin();
        if (Platform.isAndroid) {
          final androidInfo = await deviceInfoPlugin.androidInfo;
          // Check if device is an emulator
          final isEmulator = !androidInfo.isPhysicalDevice;
          if (isEmulator) {
            _isSecure = false;
            _currentThreat = SecurityThreat.emulatorDetected;
            return SecurityCheckResult(
              isSecure: false,
              threat: SecurityThreat.emulatorDetected,
              message: _getLocalizedMessage(context, 'emulator_detected'),
            );
          }
        } else if (Platform.isIOS) {
          final iosInfo = await deviceInfoPlugin.iosInfo;
          // Check if device is a simulator
          final isSimulator = !iosInfo.isPhysicalDevice;
          if (isSimulator) {
            _isSecure = false;
            _currentThreat = SecurityThreat.emulatorDetected;
            return SecurityCheckResult(
              isSecure: false,
              threat: SecurityThreat.emulatorDetected,
              message: _getLocalizedMessage(context, 'simulator_detected'),
            );
          }
        }
      } catch (e) {
        debugPrint('Emulator check error: $e');
      }

      // All checks passed
      _isSecure = true;
      _currentThreat = null;
      return SecurityCheckResult(
        isSecure: true,
        threat: null,
        message: _getLocalizedMessage(context, 'device_is_secure'),
      );
    } catch (e) {
      debugPrint('Security check error: $e');
      // On error, assume secure to avoid false positives
      return SecurityCheckResult(
        isSecure: true,
        threat: null,
        message: _getLocalizedMessage(context, 'security_check_completed'),
      );
    }
  }

  /// Get current security status
  bool get isSecure => _isSecure;
  SecurityThreat? get currentThreat => _currentThreat;

  /// Helper method to get localized messages
  String _getLocalizedMessage(BuildContext context, String key) {
    try {
      return context.tr(key);
    } catch (e) {
      debugPrint('Localization error for key $key: $e');
      return key; // Return key as fallback
    }
  }

  /// Get threat message for UI
  String getThreatMessage(BuildContext context, SecurityThreat threat) {
    try {
      switch (threat) {
        case SecurityThreat.rootDetected:
          return context.tr('security_rooted_message');
        case SecurityThreat.jailbreakDetected:
          return context.tr('security_jailbroken_message');
        case SecurityThreat.developerModeEnabled:
          return context.tr('security_developer_mode_message');
        case SecurityThreat.debugModeEnabled:
          return context.tr('security_debug_mode_message');
        case SecurityThreat.emulatorDetected:
          return context.tr('security_emulator_message');
        // case SecurityThreat.screenRecordingActive:
        //   return context.tr('security_screen_recording_message');
        // case SecurityThreat.screenshotDetected:
        //   return context.tr('security_screenshot_message');
      }
    } catch (e) {
      // Fallback to English if localization is not available
      debugPrint('Localization error: $e');
      switch (threat) {
        case SecurityThreat.rootDetected:
          return 'This app cannot run on a rooted device for security reasons.';
        case SecurityThreat.jailbreakDetected:
          return 'This app cannot run on a jailbroken device for security reasons.';
        case SecurityThreat.developerModeEnabled:
          return 'This app cannot run because developer mode is enabled. Please disable developer options in your device settings.';
        case SecurityThreat.debugModeEnabled:
          return 'This app cannot run in debug mode.';
        case SecurityThreat.emulatorDetected:
          return 'This app cannot run on an emulator or simulator.';
        // case SecurityThreat.screenRecordingActive:
        //   return 'Screen recording is not allowed for security reasons.';
        // case SecurityThreat.screenshotDetected:
        //   return 'Screenshots are not allowed for security reasons.';
      }
    }
  }
}

class SecurityCheckResult {
  final bool isSecure;
  final SecurityThreat? threat;
  final String message;

  SecurityCheckResult({
    required this.isSecure,
    required this.threat,
    required this.message,
  });
}
