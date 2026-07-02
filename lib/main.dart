import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/router/app_router.dart';
import 'core/services/deeplink_service.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_bloc_observer.dart';
import 'injection/injection_container.dart' as di;
import 'core/theme/app_colors.dart';
import 'core/services/biometric_service.dart';
import 'data/datasources/local/secure_storage_datasource.dart';

// Top-level variable — mencegah DeeplinkService di-garbage collect selama
// proses berjalan sehingga uriLinkStream tetap aktif untuk in-app deeplinks.
late final DeeplinkService _deeplinkService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = const AppBlocObserver();

  // Initialize Firebase — pastikan google-services.json/GoogleService-Info.plist sudah ada
  await Firebase.initializeApp();

  // Initialize dependency injection
  await di.init();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Status bar style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  // Simpan instance agar tidak di-GC — stream subscription harus tetap hidup
  // untuk menerima in-app deeplinks via onNewIntent (Android singleTop).
  _deeplinkService = DeeplinkService(AppRouter.router);
  await _deeplinkService.init();

  runApp(const DompetKampusApp());
}

class DompetKampusApp extends StatefulWidget {
  const DompetKampusApp({super.key});

  @override
  State<DompetKampusApp> createState() => _DompetKampusAppState();
}

class _DompetKampusAppState extends State<DompetKampusApp> with WidgetsBindingObserver {
  bool _isLocked = false;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLockOnStart();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _checkLockOnStart() async {
    // Hindari pemanggilan platform channel (BiometricService.isAvailable()) saat startup
    // karena bisa menyebabkan crash (native exception) pada beberapa device Android.
    final secureStorage = di.sl<SecureStorageDatasource>();
    final token = await secureStorage.getToken();
    if (token == null) return; // Jangan kunci jika user sudah logout

    final enabled = await secureStorage.getBiometricEnabled();
    if (enabled && mounted) {
      setState(() => _isLocked = true);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _checkAndLock();
    } else if (state == AppLifecycleState.resumed) {
      // Jangan auto-authenticate di sini, biarkan user klik tombol 
      // untuk mencegah crash platform channel saat transisi lifecycle.
    }
  }

  Future<void> _checkAndLock() async {
    final secureStorage = di.sl<SecureStorageDatasource>();
    final token = await secureStorage.getToken();
    if (token == null) return; // Jangan kunci jika user sudah logout

    final enabled = await secureStorage.getBiometricEnabled();
    if (enabled && mounted) {
      setState(() => _isLocked = true);
    }
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating) return;
    _isAuthenticating = true;
    final authenticated = await BiometricService.authenticate('Gunakan sidik jari untuk melanjutkan');
    _isAuthenticating = false;
    
    if (authenticated && mounted) {
      setState(() => _isLocked = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Service Pay',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: AppRouter.router,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Stack(
            children: [
              if (child != null) child,
              if (_isLocked)
                Positioned.fill(
                  child: Material(
                    color: AppTheme.light.scaffoldBackgroundColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lock_outline, size: 80, color: AppColors.primary),
                        const SizedBox(height: 24),
                        const Text(
                          'Aplikasi Terkunci',
                          style: TextStyle(
                            fontSize: 24, 
                            fontWeight: FontWeight.bold,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Gunakan sidik jari untuk melanjutkan',
                          style: TextStyle(fontSize: 14, color: AppColors.slate500),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton.icon(
                          onPressed: _authenticate,
                          icon: const Icon(Icons.fingerprint),
                          label: const Text('Buka Kunci'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200, 54),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
