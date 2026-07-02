import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/biometric_service.dart';
import '../../../data/datasources/local/secure_storage_datasource.dart';
import '../../../injection/injection_container.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_field.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/feature_icon.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '';
  String _pw = '';
  bool _showPw = false;
  bool _gLoading = false;
  bool _biometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    final available = await BiometricService.isAvailable();
    if (available) {
      setState(() => _biometricAvailable = true);
    }
  }

  Future<void> _loginWithBiometrics() async {
    try {
      final enabled = await sl<SecureStorageDatasource>().getBiometricEnabled();
      if (!enabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Silakan aktifkan login biometrik terlebih dahulu di halaman Profil/Akun.'),
              backgroundColor: AppColors.primary,
            ),
          );
        }
        return;
      }

      final authenticated = await BiometricService.authenticate(
        'Login ke Service Pay menggunakan sidik jari',
      );
      if (!authenticated) return;

      final credentials = await sl<SecureStorageDatasource>().getCredentials();
      if (credentials == null || credentials.password.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Akun Google tidak dapat menggunakan sidik jari untuk login. Silakan masuk menggunakan tombol Google.'),
              backgroundColor: AppColors.primary,
            ),
          );
        }
        return;
      }

      setState(() {
        _email = credentials.email;
        _pw = credentials.password;
      });

      // Otomatis login dengan kredensial tersebut
      await _loginWithEmail();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login biometrik gagal: $e'), backgroundColor: AppColors.red),
        );
      }
    }
  }

  bool get _valid => _email.contains('@') && _pw.length >= 4;

  Future<void> _loginWithGoogle() async {
    setState(() => _gLoading = true);
    try {
      debugPrint('[Auth] Google sign-in: memulai...');
      final googleSignIn = GoogleSignIn();
      // Keluar dari sesi Google yang ter-cache agar dialog pilih akun selalu muncul
      await googleSignIn.signOut();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        debugPrint('[Auth] Google sign-in: dibatalkan user');
        setState(() => _gLoading = false);
        return;
      }
      debugPrint('[Auth] Google sign-in: akun dipilih → ${googleUser.email}');

      final googleAuth = await googleUser.authentication;
      debugPrint(
          '[Auth] Google auth: accessToken=${googleAuth.accessToken != null ? "OK" : "NULL"}, '
          'idToken=${googleAuth.idToken != null ? "OK" : "NULL"}');

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      debugPrint('[Auth] Firebase sign-in OK → uid=${userCredential.user?.uid}');

      final idToken = await userCredential.user?.getIdToken();
      debugPrint(
          '[Auth] Firebase ID token: ${idToken != null ? "OK (${idToken.length} chars)" : "NULL"}');

      if (idToken != null && mounted) {
        debugPrint('[Auth] Kirim token ke backend → POST /v1/auth/verify-token');
        context.read<AuthBloc>().add(AuthLoginWithFirebase(idToken));
      }
    } catch (e, st) {
      debugPrint('[Auth] Google sign-in ERROR: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Google gagal: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _gLoading = false);
    }
  }

  Future<void> _loginWithEmail() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _pw,
      );
      final idToken = await userCredential.user?.getIdToken();
      if (idToken != null && mounted) {
        final authBloc = context.read<AuthBloc>();
        await sl<SecureStorageDatasource>().saveCredentials(_email, _pw);
        authBloc.add(AuthLoginWithFirebase(idToken));
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Login gagal.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthNeedsVerification) {
          final method = state.user.twoFaMethod;
          if (method == AppConstants.twoFaNotif) {
            context.go('/2fa/notif');
          } else if (method == AppConstants.twoFaTotp) {
            context.go('/2fa/totp');
          } else {
            context.go('/2fa/smtp');
          }
        } else if (state is AuthAuthenticated) {
          context.go('/home');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          child: Column(
            children: [
              // Circular Back Button
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.go('/welcome'),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: AppColors.shadowSoft,
                          border: Border.all(color: AppColors.line, width: 1),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.ink),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    children: [
                      // Centered Logo & Brand Name
                      const Center(
                        child: AppLogo(size: 64, withText: true),
                      ),
                      const SizedBox(height: 28),
                      // Floating Form Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: AppColors.shadowCard,
                          border: Border.all(color: AppColors.line, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Masuk',
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.ink,
                                  letterSpacing: -0.4,
                                )),
                            const SizedBox(height: 6),
                            const Text('Selamat datang kembali di Service Pay',
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 13.5,
                                  color: AppColors.slate500,
                                )),
                            const SizedBox(height: 24),
                            // Google sign in button
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                final loading = state is AuthLoading || _gLoading;
                                return GestureDetector(
                                  onTap: loading ? null : _loginWithGoogle,
                                  child: Container(
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(color: AppColors.line, width: 1.5),
                                      boxShadow: AppColors.shadowSoft,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: loading
                                          ? const [
                                              SizedBox(
                                                width: 18,
                                                height: 18,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2.2,
                                                  valueColor: AlwaysStoppedAnimation(AppColors.primary),
                                                ),
                                              ),
                                              SizedBox(width: 11),
                                              Text('Menghubungkan…',
                                                  style: TextStyle(
                                                    fontFamily: 'PlusJakartaSans',
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.slate600,
                                                  )),
                                            ]
                                          : const [
                                              _GoogleIcon(),
                                              SizedBox(width: 11),
                                              Text('Lanjut dengan Google',
                                                  style: TextStyle(
                                                    fontFamily: 'PlusJakartaSans',
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.ink,
                                                  )),
                                            ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            Row(children: [
                              const Expanded(child: Divider(color: AppColors.line)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: const Text('atau email',
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.slate400,
                                    )),
                              ),
                              const Expanded(child: Divider(color: AppColors.line)),
                            ]),
                            const SizedBox(height: 20),
                            AppField(
                              label: 'Email',
                              value: _email,
                              onChanged: (v) => setState(() => _email = v),
                              placeholder: 'nama@email.com',
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: const Icon(DkgIcons.mail, size: 20),
                            ),
                            const SizedBox(height: 16),
                            AppField(
                              label: 'Kata sandi',
                              value: _pw,
                              onChanged: (v) => setState(() => _pw = v),
                              obscureText: !_showPw,
                              placeholder: '••••••••',
                              prefixIcon: const Icon(DkgIcons.lock, size: 20),
                              suffixIcon: IconButton(
                                icon: Icon(_showPw ? DkgIcons.eyeOff : DkgIcons.eye,
                                    size: 20, color: AppColors.slate400),
                                onPressed: () => setState(() => _showPw = !_showPw),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text('Lupa kata sandi?',
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    )),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: BlocBuilder<AuthBloc, AuthState>(
                                    builder: (context, state) => AppButton(
                                      label: 'Masuk',
                                      onPressed: _valid ? _loginWithEmail : null,
                                      isLoading: state is AuthLoading,
                                    ),
                                  ),
                                ),
                                if (_biometricAvailable) ...[
                                  const SizedBox(width: 12),
                                  GestureDetector(
                                    onTap: _loginWithBiometrics,
                                    child: Container(
                                      height: 52,
                                      width: 52,
                                      decoration: BoxDecoration(
                                        color: AppColors.primarySurface,
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(color: AppColors.primaryLight, width: 1.5),
                                        boxShadow: AppColors.shadowSoft,
                                      ),
                                      child: const Icon(
                                        Icons.fingerprint_rounded,
                                        color: AppColors.primary,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Belum punya akun? ',
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      fontSize: 13.5,
                                      color: AppColors.slate500,
                                    )),
                                GestureDetector(
                                  onTap: () => context.go('/register'),
                                  child: const Text('Daftar',
                                      style: TextStyle(
                                        fontFamily: 'PlusJakartaSans',
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.5,
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 21,
      height: 21,
      child: Image.network(
        'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/24px-Google_%22G%22_logo.svg.png',
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.g_mobiledata_rounded, size: 24, color: Colors.red),
      ),
    );
  }
}
