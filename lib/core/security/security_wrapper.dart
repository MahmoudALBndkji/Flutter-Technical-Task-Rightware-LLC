import 'package:flutter/material.dart';
import 'package:flutter_technical_task_rightware_llc/core/routing/app_paths.dart';
import 'package:flutter_technical_task_rightware_llc/core/services/security_service.dart';
import 'package:flutter_technical_task_rightware_llc/core/widgets/logo_animation_loading.dart';
import 'package:go_router/go_router.dart';

/// Security wrapper widget that checks security on all screens
class SecurityWrapper extends StatefulWidget {
  final Widget child;
  const SecurityWrapper({super.key, required this.child});

  @override
  State<SecurityWrapper> createState() => _SecurityWrapperState();
}

class _SecurityWrapperState extends State<SecurityWrapper> {
  final SecurityService _securityService = SecurityService();
  bool _isChecking = true;
  bool _isSecure = true;

  @override
  void initState() {
    super.initState();
    _checkSecurity();
    // Periodically check security (every 2 seconds)
    _startPeriodicCheck();
  }

  Future<void> _checkSecurity() async {
    if (!mounted) return;
    final result = await _securityService.performSecurityCheck(context);
    if (mounted) {
      setState(() {
        _isChecking = false;
        _isSecure = result.isSecure;
      });
      // If not secure, navigate to restricted screen
      if (!_isSecure && result.threat != null) {
        final currentPath = GoRouterState.of(context).uri.path;
        // Only navigate if not already on restricted screen
        if (currentPath != AppPaths.restricted) {
          context.go('${AppPaths.restricted}?threat=${result.threat!.name}');
        }
      }
    }
  }

  void _startPeriodicCheck() {
    Future.delayed(const Duration(minutes: 2), () {
      if (mounted) {
        _checkSecurity();
        _startPeriodicCheck(); // Continue checking
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(body: Center(child: LogoAnimationLoading()));
    }

    if (!_isSecure) {
      // Return empty container, navigation will handle the restricted screen
      return const SizedBox.shrink();
    }

    return widget.child;
  }
}
