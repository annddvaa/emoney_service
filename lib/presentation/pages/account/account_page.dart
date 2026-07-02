import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/biometric_service.dart';
import '../../../data/datasources/local/secure_storage_datasource.dart';
import '../../../injection/injection_container.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../widgets/app_avatar.dart';
import '../../widgets/app_badge.dart';
import '../../widgets/feature_icon.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go('/');
        }
      },
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;

        return Scaffold(
          backgroundColor: AppColors.bg,
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Header
                Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(
                      20, MediaQuery.of(context).padding.top + 12, 20, 24),
                  child: Row(
                    children: [
                      AppAvatar(name: user?.name ?? 'User', size: 60, bg: Colors.white.withValues(alpha: 0.25)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user?.name ?? 'Pengguna',
                                style: const TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                )),
                            Text(user?.email ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 13,
                                  color: Colors.white70,
                                )),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.verified_user_outlined, size: 14, color: Colors.white),
                            SizedBox(width: 5),
                            Text('Terverifikasi',
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 8),
                        child: Text('Keamanan',
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.slate400,
                            )),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: AppColors.shadowSoft,
                        ),
                        child: Column(
                          children: [
                            _Row(
                              icon: Icons.verified_user_outlined,
                              tone: 'green',
                              title: 'Verifikasi 2 langkah (2FA)',
                              subtitle: 'Aktif · Email OTP',
                              onTap: () => context.go('/setup-2fa'),
                              right: const AppBadge(label: 'Aktif', tone: 'green'),
                            ),
                            const Divider(height: 1, indent: 56, color: AppColors.line2),
                            _Row(
                               icon: Icons.lock_outline_rounded,
                               tone: 'blue',
                               title: 'Ubah PIN keamanan',
                               subtitle: 'Terakhir diubah 2 bln lalu',
                               onTap: () => _showChangePinDialog(context),
                             ),
                            const Divider(height: 1, indent: 56, color: AppColors.line2),
                            _Row(
                              icon: Icons.fingerprint_rounded,
                              tone: 'violet',
                              title: 'Biometrik (Masuk & Bayar)',
                              subtitle: 'Sidik jari untuk masuk & transaksi',
                              onTap: () {},
                              right: _Toggle(email: user?.email),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 8),
                        child: Text('Akun',
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.slate400,
                            )),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: AppColors.shadowSoft,
                        ),
                        child: Column(
                          children: [
                            _Row(icon: Icons.person_outline_rounded, tone: 'blue', title: 'Data pribadi', onTap: () {}),
                            const Divider(height: 1, indent: 56, color: AppColors.line2),
                            _Row(icon: Icons.account_balance_outlined, tone: 'green', title: 'Rekening & kartu tersimpan', onTap: () {}),
                            const Divider(height: 1, indent: 56, color: AppColors.line2),
                            _Row(icon: Icons.settings_outlined, tone: 'slate', title: 'Pengaturan aplikasi', onTap: () {}),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      GestureDetector(
                        onTap: () => context.read<AuthBloc>().add(AuthLogoutRequested()),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: AppColors.shadowSoft,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout_rounded, size: 20, color: AppColors.red),
                              SizedBox(width: 9),
                              Text('Keluar',
                                  style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    color: AppColors.red,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Center(
                        child: Text('Service Pay · v1.0.0',
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 12,
                              color: AppColors.slate400,
                            )),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showChangePinDialog(BuildContext context) {
    final currentPinController = TextEditingController();
    final newPinController = TextEditingController();
    final confirmPinController = TextEditingController();
    bool loading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text(
                'Ubah PIN Keamanan',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ubah 6 digit PIN untuk transaksi dan pembayaran.',
                      style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 13, color: AppColors.slate500),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: currentPinController,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                        hintText: 'PIN Sekarang (Default: 123456)',
                        counterText: '',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: newPinController,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                        hintText: 'PIN Baru',
                        counterText: '',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: confirmPinController,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                        hintText: 'Konfirmasi PIN Baru',
                        counterText: '',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: loading ? null : () => Navigator.pop(context),
                  child: const Text('Batal', style: TextStyle(color: AppColors.slate500)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(80, 40),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: loading
                      ? null
                      : () async {
                          final currentPin = currentPinController.text.trim();
                          final newPin = newPinController.text.trim();
                          final confirmPin = confirmPinController.text.trim();

                          if (currentPin.length != 6 || newPin.length != 6 || confirmPin.length != 6) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('PIN harus terdiri dari 6 digit.'),
                                backgroundColor: AppColors.red,
                              ),
                            );
                            return;
                          }

                          if (newPin != confirmPin) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Konfirmasi PIN baru tidak cocok.'),
                                backgroundColor: AppColors.red,
                              ),
                            );
                            return;
                          }

                          setDialogState(() => loading = true);

                          final storage = sl<SecureStorageDatasource>();
                          final savedPin = await storage.getPin() ?? '123456';

                          if (currentPin != savedPin) {
                            setDialogState(() => loading = false);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('PIN sekarang salah.'),
                                  backgroundColor: AppColors.red,
                                ),
                              );
                            }
                            return;
                          }

                          await storage.savePin(newPin);

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('PIN keamanan berhasil diubah!'),
                                backgroundColor: AppColors.green,
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                  child: loading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String tone;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Widget? right;

  const _Row({
    required this.icon,
    required this.tone,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            FeatureIcon(icon: icon, tone: tone, size: 42, iconSize: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      )),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!,
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 12.5,
                          color: AppColors.slate400,
                        )),
                  ],
                ],
              ),
            ),
            right ?? const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.slate400),
          ],
        ),
      ),
    );
  }
}

class _Toggle extends StatefulWidget {
  final String? email;
  const _Toggle({super.key, this.email});

  @override
  State<_Toggle> createState() => _ToggleState();
}

class _ToggleState extends State<_Toggle> {
  bool _on = false;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final enabled = await sl<SecureStorageDatasource>().getBiometricEnabled();
    setState(() => _on = enabled);
  }

  Future<void> _showPasswordDialog(String email, bool isGoogle) async {
    final pinController = TextEditingController();
    final pwController = TextEditingController();
    bool loading = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              title: const Text('Aktifkan Sidik Jari',
                  style: TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isGoogle
                        ? 'Masukkan PIN keamanan Anda untuk mengaktifkan biometrik pembayaran.'
                        : 'Masukkan PIN keamanan dan Kata Sandi Akun Anda untuk mengaktifkan biometrik masuk & pembayaran.',
                    style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 13, color: AppColors.slate500),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: pinController,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      hintText: 'PIN Keamanan',
                      counterText: '',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  if (!isGoogle) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: pwController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Kata Sandi Akun',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: loading ? null : () => Navigator.pop(context),
                  child: const Text('Batal', style: TextStyle(color: AppColors.slate500)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(80, 40),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: loading
                      ? null
                      : () async {
                          final pinInput = pinController.text.trim();
                          final pwInput = pwController.text;
                          if (pinInput.length != 6) return;
                          if (!isGoogle && pwInput.isEmpty) return;

                          setDialogState(() => loading = true);

                          try {
                            // 1. Cek Ketersediaan Biometrik
                            final isAvailable = await BiometricService.isAvailable();
                            if (!isAvailable) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Perangkat tidak mendukung biometrik atau belum didaftarkan.'),
                                    backgroundColor: AppColors.red,
                                  ),
                                );
                              }
                              Navigator.pop(context);
                              return;
                            }

                            // 2. Scan Sidik Jari
                            final authenticated = await BiometricService.authenticate(
                              isGoogle
                                  ? 'Konfirmasi sidik jari untuk mengaktifkan biometrik pembayaran'
                                  : 'Konfirmasi sidik jari untuk mengaktifkan biometrik masuk & pembayaran',
                            );

                            if (!authenticated) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Sidik jari tidak cocok.'),
                                    backgroundColor: AppColors.red,
                                  ),
                                );
                              }
                              Navigator.pop(context);
                              return;
                            }

                            // 3. Verifikasi PIN Keamanan
                            final storage = sl<SecureStorageDatasource>();
                            final savedPin = await storage.getPin() ?? '123456';

                            if (pinInput != savedPin) {
                              setDialogState(() => loading = false);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('PIN keamanan salah.'),
                                    backgroundColor: AppColors.red,
                                  ),
                                );
                              }
                              return;
                            }

                            // 4. Verifikasi Password dengan Firebase Auth & Simpan Kredensial (Hanya jika bukan Google)
                            if (!isGoogle) {
                              try {
                                await FirebaseAuth.instance.signInWithEmailAndPassword(
                                  email: email,
                                  password: pwInput,
                                );
                                await storage.saveCredentials(email, pwInput);
                              } on FirebaseAuthException catch (e) {
                                setDialogState(() => loading = false);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Kata sandi salah: ${e.message}'),
                                      backgroundColor: AppColors.red,
                                    ),
                                  );
                                }
                                return;
                              }
                            } else {
                              // Akun Google: simpan email dan password kosong
                              await storage.saveCredentials(email, '');
                            }

                            // Aktifkan biometrik masuk & pembayaran
                            await storage.saveBiometricEnabled(true);
                            setState(() => _on = true);

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(isGoogle
                                      ? 'Biometrik pembayaran berhasil diaktifkan!'
                                      : 'Biometrik masuk & pembayaran berhasil diaktifkan!'),
                                  backgroundColor: AppColors.green,
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Gagal mengaktifkan biometrik: $e'),
                                  backgroundColor: AppColors.red,
                                ),
                              );
                            }
                          } finally {
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          }
                        },
                  child: loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                        )
                      : const Text('Konfirmasi'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (_on) {
          // Matikan biometrik
          final storage = sl<SecureStorageDatasource>();
          await storage.saveBiometricEnabled(false);
          await storage.deleteCredentials();
          setState(() => _on = false);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Biometrik masuk & pembayaran dinonaktifkan.'),
                backgroundColor: AppColors.slate600,
              ),
            );
          }
        } else {
          // Aktifkan biometrik
          final user = FirebaseAuth.instance.currentUser;
          final isGoogle = user?.providerData.any((p) => p.providerId == 'google.com') ?? false;
          if (widget.email == null || widget.email!.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Email user tidak ditemukan.'),
                backgroundColor: AppColors.red,
              ),
            );
            return;
          }
          await _showPasswordDialog(widget.email!, isGoogle);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 44,
        height: 26,
        decoration: BoxDecoration(
          color: _on ? AppColors.green : AppColors.line,
          borderRadius: BorderRadius.circular(20),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 180),
          alignment: _on ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(3),
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 1))],
            ),
          ),
        ),
      ),
    );
  }
}
