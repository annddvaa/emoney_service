import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/error/failures.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/usecases/auth/register_with_otp_usecase.dart';
import '../../../data/datasources/local/secure_storage_datasource.dart';
import '../../../injection/injection_container.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_field.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/feature_icon.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _name = '';
  String _email = '';
  String _pw = '';
  bool _showPw = false;
  bool _agree = true;
  bool _loading = false;

  bool get _valid => _name.length > 1 && _email.contains('@') && _pw.length >= 6 && _agree;

  Future<void> _register() async {
    setState(() => _loading = true);
    try {
      // 1. Buat akun di Firebase
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email,
        password: _pw,
      );
      await credential.user?.updateDisplayName(_name);

      // 2. Ambil Firebase ID Token lalu kirim ke backend
      final idToken = await credential.user?.getIdToken();
      if (idToken == null) throw Exception('Gagal mendapatkan token Firebase');

      await sl<RegisterWithOtpUsecase>()(idToken);
      await sl<SecureStorageDatasource>().saveCredentials(_email, _pw);

      // 3. Backend sudah buat user + kirim OTP ke email → ke halaman verifikasi
      if (mounted) context.go('/verify-email');
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Registrasi gagal.'), backgroundColor: AppColors.red),
        );
      }
    } on ServerFailure catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: AppColors.red),
        );
      }
    } on NetworkFailure catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak ada koneksi internet.'), backgroundColor: AppColors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          const Text('Buat akun',
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: AppColors.ink,
                                letterSpacing: -0.4,
                              )),
                          const SizedBox(height: 6),
                          const Text('Daftar gratis dalam 1 menit',
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 13.5,
                                color: AppColors.slate500,
                              )),
                          const SizedBox(height: 24),
                          AppField(
                            label: 'Nama lengkap',
                            value: _name,
                            onChanged: (v) => setState(() => _name = v),
                            placeholder: 'Nama Lengkap',
                            prefixIcon: const Icon(DkgIcons.user, size: 20),
                          ),
                          const SizedBox(height: 14),
                          AppField(
                            label: 'Email',
                            value: _email,
                            onChanged: (v) => setState(() => _email = v),
                            placeholder: 'nama@email.com',
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(DkgIcons.mail, size: 20),
                          ),
                          const SizedBox(height: 14),
                          AppField(
                            label: 'Kata sandi',
                            value: _pw,
                            onChanged: (v) => setState(() => _pw = v),
                            obscureText: !_showPw,
                            placeholder: 'Min. 6 karakter',
                            prefixIcon: const Icon(DkgIcons.lock, size: 20),
                            suffixIcon: IconButton(
                              icon: Icon(_showPw ? DkgIcons.eyeOff : DkgIcons.eye,
                                  size: 20, color: AppColors.slate400),
                              onPressed: () => setState(() => _showPw = !_showPw),
                            ),
                          ),
                          const SizedBox(height: 18),
                          GestureDetector(
                            onTap: () => setState(() => _agree = !_agree),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: _agree ? AppColors.primary : Colors.white,
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(
                                      color: _agree ? AppColors.primary : AppColors.line,
                                      width: 1.6,
                                    ),
                                  ),
                                  child: _agree
                                      ? const Icon(DkgIcons.check, size: 14, color: Colors.white)
                                      : null,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: RichText(
                                    text: const TextSpan(
                                      style: TextStyle(
                                        fontFamily: 'PlusJakartaSans',
                                        fontSize: 13,
                                        color: AppColors.slate500,
                                        height: 1.5,
                                      ),
                                      children: [
                                        TextSpan(text: 'Saya setuju dengan '),
                                        TextSpan(
                                          text: 'Syarat & Ketentuan',
                                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
                                        ),
                                        TextSpan(text: ' dan '),
                                        TextSpan(
                                          text: 'Kebijakan Privasi',
                                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
                                        ),
                                        TextSpan(text: '.'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          AppButton(
                            label: 'Daftar',
                            onPressed: _valid ? _register : null,
                            isLoading: _loading,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Sudah punya akun? ',
                                  style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: 13.5,
                                    color: AppColors.slate500,
                                  )),
                              GestureDetector(
                                onTap: () => context.go('/login'),
                                child: const Text('Masuk',
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
    );
  }
}
